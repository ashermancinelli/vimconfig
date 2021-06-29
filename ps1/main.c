#include <unistd.h>
#include <dirent.h>
#include <stdio.h>
#include <string.h>
#include <limits.h>
#include <stdlib.h>
#include <sys/utsname.h>
#include <errno.h>

#include "resources.h"

#define BUFSZ 1024

static void get_machine_name(char* name)
{
  struct utsname buffer;

  errno = 0;
  if (uname(&buffer) < 0) {
    perror("uname");
    exit(EXIT_FAILURE);
  }

  strcpy(name, buffer.nodename);
}

static void get_user_name(char* name)
{
  char* slurm_id = getenv("SLURM_JOB_ID");
  if (slurm_id != NULL)
  {
    strcpy(name, "job #");
    strcat(name, slurm_id);
    return;
  }
  getlogin_r(name, BUFSZ);
}

static void get_dir(char* dir)
{
  getcwd(dir, PATH_MAX);

  char* home = getenv("HOME");
  char* home_ptr = strstr(dir, home);
  /* We found ~ in our cwd! */
  if (home_ptr != NULL)
  {
    /* Set the start of _dir_ to "~/" */
    char* dir_it = dir;
    *dir_it++ = '~';

    /* Start of remainder of path */
    char* rest_it = dir + strlen(home);

    /* Copy remainder of path to _dir_ */
    int i;
    for (i=0; i < strlen(dir) - strlen(home); i++)
    {
      *dir_it++ = *rest_it++;
    }
    *dir_it++ = '\0';
  }
}

static int is_in_repo()
{
  char cmd[BUFSZ] = "git rev-parse --git-dir 2>&1 >/dev/null";
  FILE* fp = popen(cmd, "r");
  if (!fp)
  {
    perror("fopen");
    exit(EXIT_FAILURE);
  }
  int ec;
  ec = pclose(fp);
  return ec == 0;
}

static void get_current_branch(char* branch)
{
  char cmd[BUFSZ] = "git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \\(.*\\)/\\1/'";
  FILE* fp = popen(cmd, "r");
  if (!fp)
  {
    perror("fopen");
    exit(EXIT_FAILURE);
  }

  char out[BUFSZ];
  fgets(out, sizeof(out), fp);
  pclose(fp);
  strcpy(branch, out);
  char* i;
  for (i = branch; i != (branch+strlen(branch)); i++)
  {
    if (*i == '\n')
    {
      *i = 0;
      break;
    }
  }
}

int main(int argc, char** argv)
{
  char ps1[BUFSZ];
  memset(ps1, 0, BUFSZ);

  char username[BUFSZ];
  get_user_name(username);
  strcat(ps1, BLUE);
  strcat(ps1, username);

  strcat(ps1, RESET DIM " at " RESET YELLOW);

  char machine_name[BUFSZ];
  get_machine_name(machine_name);
  strcat(ps1, machine_name);

  strcat(ps1, RESET DIM " in " RESET GREEN);

  char dir[PATH_MAX];
  get_dir(dir);
  strcat(ps1, dir);

  if (is_in_repo())
  {
    char branch[PATH_MAX];
    get_current_branch(branch);
    strcat(ps1, RESET DIM " on " RESET PURPLE);
    strcat(ps1, branch);
  }

  strcat(ps1, RESET " $ ");
  printf("%s", ps1);
  return EXIT_SUCCESS;
}
