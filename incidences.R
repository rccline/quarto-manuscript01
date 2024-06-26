library(tidyverse)
library(medicaldata)
library(patchwork)

# data(package = "medicaldata")
data(indo_rct)


plot_a <- indo_rct |> 
  count(rx, outcome) |>
  group_by(rx) |>
  mutate(p = n / sum(n)) |>
  filter(outcome == "1_yes") |>
  ungroup() |>
  mutate(
    rx = case_match(
      rx, 
      "0_placebo" ~ "Placebo",
      "1_indomethacin" ~ "Indomethacin"
    ),
    rx = fct_relevel(rx, "Placebo", "Indomethacin"),
    p = p*100
  ) |>
  ggplot(aes(x = rx, y = p, fill = rx)) +
  geom_col(color = "black") +
  scale_fill_manual(
    values = c(
      "Placebo" = "azure2", 
      "Indomethacin" =  "deepskyblue4"
    )
  ) + 
  theme_classic() +
  theme(
    legend.position = "top",
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank()
  ) +
  ylim(0, 20) +
  labs(
    x = "All Post-ERCP\nPancreatitis",
    y = "Patients (%)",
    fill = NULL
  )

# renal failure missing
plot_b <- indo_rct |>
  filter(bleed == 1) |>
  mutate(
    rx = case_match(
      rx, 
      "0_placebo" ~ "Placebo",
      "1_indomethacin" ~ "Indomethacin"
    ),
    rx = fct_relevel(rx, "Placebo", "Indomethacin")
  ) |>
  count(rx, bleed) |>
  ggplot(aes(x = rx, y = n, fill = rx)) +
  geom_col(color = "black") +
  scale_fill_manual(
    values = c(
      "Placebo" = "azure2", 
      "Indomethacin" =  "deepskyblue4"
    )
  ) + 
  theme_classic() +
  theme(
    legend.position = "top",
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank()
  ) +
  ylim(0, 8) +
  labs(
    x = "Gastrointestinal\nBleeding",
    y = "No. of Adverse Events",
    fill = NULL
  )

plot_a + plot_b