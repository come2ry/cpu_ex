#define EXTIO_SCAN_ASCII (*(volatile unsigned int *)0x0310)
#define EXTIO_SCAN_REQ (*(volatile unsigned int *)0x030c)
#define EXTIO_SCAN_STROKE (*(volatile unsigned int *)0x0308)

#define SCAN_STRORING (unsigned int)0xffffffff

#define EXTIO_PRINT_STROKE (*(volatile unsigned int *) 0x0300)
#define EXTIO_PRINT_ASCII  (*(volatile unsigned int *) 0x0304)

#define TRUE    0x1
#define FALSE   0x0

#define GPIO0 (*(volatile unsigned int *) 0x0320)

void my_forward_motor();
void my_backward_motor();
void ext_out();
void my_scan();
unsigned int my_a2i();


main() {
  int is_forward = 1;
  unsigned int k;
  unsigned int str1[16];
  my_scan(str1);
  k = my_a2i(str1);

  while(1){
    if (k == 2) {
      my_backward_motor();
    } else {
      my_forward_motor();
    }
  }
} 
 
void my_forward_motor() {
  ext_out(8); 
  ext_out(4); 
  ext_out(2); 
  ext_out(1); 
} 

void my_backward_motor() {
  ext_out(1); 
  ext_out(2); 
  ext_out(4); 
  ext_out(8); 
} 
 
void ext_out(unsigned int num) {
  unsigned int i;

  GPIO0 = num; 
}

void my_scan(str)
     unsigned int *str;
{
    EXTIO_SCAN_STROKE = (unsigned int)0x00000000;
    EXTIO_SCAN_REQ = (unsigned int)0x00000001;
    EXTIO_SCAN_STROKE = (unsigned int)0x00000001;

    EXTIO_SCAN_STROKE = (unsigned int)0x00000000;
    EXTIO_SCAN_STROKE = (unsigned int)0x00000001;
    while (EXTIO_SCAN_ASCII == SCAN_STRORING) {
      EXTIO_SCAN_STROKE = (unsigned int)0x00000000;
      EXTIO_SCAN_STROKE = (unsigned int)0x00000001;
    }

    while ((*str = EXTIO_SCAN_ASCII) != (unsigned int)0x3e) {    // 0x3e=RETURN
      if ((*str >= 1) && (*str <= 26)) {
	*str = 'A' + *str - 1;
      } else if ((*str >= 48) && (*str <= 57)) {
	*str = '0' + *str - 48;
      } else {
	if (*str == 0) {
	  *str = '@';
	} else if (*str == 27) {
	  *str = '[';
	} else if (*str == 29) {
	  *str = ']';
	} else if ((*str >= 32) && (*str <= 47)) {
	  *str = ' ' + *str - 32;
	} else if (*str == 58) {
	  *str = '?';
	} else if (*str == 59) {
	  *str = '=';
	} else if (*str == 60) {
	  *str = ';';
	} else if (*str == 61) {
	  *str = ':';
	} else if (*str == 62) {
	  *str = '\n';
	} else {
	  *str = '@';
	}
      }
      EXTIO_SCAN_STROKE = (unsigned int)0x00000000;
      EXTIO_SCAN_STROKE = (unsigned int)0x00000001;
      str++;
    }
    *str = '\0';

    EXTIO_SCAN_STROKE = (unsigned int)0x00000000;
    EXTIO_SCAN_REQ = (unsigned int)0x00000000;
    EXTIO_SCAN_STROKE = (unsigned int)0x00000001;

    EXTIO_SCAN_STROKE = (unsigned int)0x00000000;
}

unsigned int my_a2i(str)
     unsigned int *str;
{
  unsigned int *str_tmp;
  unsigned int k;
  unsigned int result;

  str_tmp = str;
  for (k = 0; *str_tmp != '\0'; k++) {
    str_tmp++;
  }

  result = 0;
  str_tmp = str;
  
  if (k == 1) {
    result = *str_tmp - '0';
  } else if (k == 2) {
    for (k = 0; k < (*str_tmp - '0'); k++) {
      result = result + 10;
    }
    str_tmp++;
    result = result + (*str_tmp - '0');
  } else if (k == 3) {
    for (k = 0; k < (*str_tmp - '0'); k++) {
      result = result + 100;
    }
    str_tmp++;
    for (k = 0; k < (*str_tmp - '0'); k++) {
      result = result + 10;
    }
    str_tmp++;
    result = result + (*str_tmp - '0');
  }

  return result;
}