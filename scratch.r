library(tidyverse)

df <- tibble(
             a = 1,
             b = 2,
             c = 3
             )

df %>%
    mutate(
           a = a + 1
           ) %>%
select(a, b) %>%
filter(b >= 2)

# vim: ts=4 sts=4 sw=4 et
