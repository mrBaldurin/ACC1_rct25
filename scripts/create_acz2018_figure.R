# ------------------------------------------------------------------------------
# Code to visually reproduce the profit effect of
# Anderson, Chandy, and Zhia (2018): 
# Pathways to Profits: The Impact of Marketing vs. Finance Skills 
# on Business Performance
# https://pubsonline.informs.org/doi/suppl/10.1287/mnsc.2017.2920
# Compare to Table 5 of Anderson et. al (p. 5571)
# ------------------------------------------------------------------------------

suppressWarnings(suppressPackageStartupMessages({
	library(tidyverse)
	library(haven)
}))

# Data can be obtained at 
# https://pubsonline.informs.org/doi/suppl/10.1287/mnsc.2017.2920
raw_dta <- read_dta("data/external/acz2018.dta")

df <- raw_dta %>%
	filter(T_survey_round == 3, !is.na(Profits1_aidedrecall_w1)) %>% 
	# endline sample profit estimate present
	transmute(
		firm_id = N_firm_id,
		tment = case_when(
			Treatment_FIN == 1 ~ "Finance/Accounting",
			Treatment_MKT == 1 ~ "Marketing",
			TRUE ~ "Control"
		),
		profits_pre = pre_Profits1_aidedrecall_w1,
		profits_post = Profits1_aidedrecall_w1
	) %>%
	pivot_longer(
		-c(firm_id, tment), names_to = c(".value", "period"), names_sep = "_"
	)

avgs <- df %>%
	group_by(period, tment) %>%
	summarise(
	  # mn_profits = mean(profits),
		mn_profits = median(profits),
		lb_profits = mn_profits - 1.96*sd(profits)/sqrt(n()),
		ub_profits = mn_profits + 1.96*sd(profits)/sqrt(n()),
		.groups = "drop"
	)

avgs$period <- factor(
	avgs$period, levels = c("pre", "post"),
	labels = c("Pre training", "~12 months after training")
)

pl <- ggplot(avgs, aes(x = period, group = tment, color = tment)) + 
	geom_pointrange(
		aes(y = mn_profits, ymin = lb_profits, ymax = ub_profits), 
		position = position_dodge(width = 0.1)
	) +
	geom_line(aes(y = mn_profits), position = position_dodge(width = 0.1)) +
	labs(
		color = "Treatment", x = "", y = "", 
		title =  "Anderson, Chandy, and Zhia (Management Science, 2018)",
		subtitle = "Training Effect on Recalled Monthly Profits [South African Rand]"
	) +
	scale_y_continuous(labels = function(x) format(x, big.mark = ",")) +
	theme_minimal() + 
	theme(
		legend.position = "bottom",
		panel.grid.minor = element_blank(),
		panel.grid.major.x = element_blank()
	)

<<<<<<< HEAD


ggsave("output/acz2018_figure.pdf", width = 9, height = 6)




# ------------------------------------------------------------------------------

# Difference to the paper table, due to difference in differences.
# The original table is a DiD table, takes difference for e.g. Finance group and subtracts the difference in the control group.
# IN our case, it shifts the effect of Finance upwards, since the control group had a decrease. DiD assumes a parallel trend 
# which gets broken when the treatment is implemented. The counter factual is the difference that would have happend to the 
# treatment groups if the treatment would not have been introduced. The counter factual cannot be observed but need to be 
# estimated by the model.

# When using the median instead of the average the effect is even more pronounced.

# ------------------------------------------------------------------------------




=======
ggsave("output/acz2018_figure.pdf", pl, width = 9, height = 6)
>>>>>>> upstream/main
