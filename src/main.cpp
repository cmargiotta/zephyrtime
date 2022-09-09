#include <sys/printk.h>
#include <zephyr.h>

/* 1000 msec = 1 sec */
#define SLEEP_TIME_MS 1000

void main(void) {
  while (1) {
    printk("Hello world! %s\n", CONFIG_BOARD);
    k_msleep(SLEEP_TIME_MS);
  }
}