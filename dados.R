# devtools::install_github("gabrielzanlorenssi/extfunctions")
library(ext.functions)

x <- c("readxl", "tidyr", "dplyr", "ggplot2", "stringi", "stringr")
set.library(x)

tabela <- read_excel("Tabela 5938 (1).xlsx", 
                          skip = 3)

colnames(tabela) <- c("mun", "total", "agropecuaria", "industria", "servicos", "adm")

tabela2 <- tabela %>% 
  separate(mun, c("mun", "uf"), sep="[(]") %>% 
  mutate(uf = str_replace_all(uf, "[)]", ""),
         s_agropecuaria = round(agropecuaria / total, digits = 2),
         s_industria = round(industria / total, digits = 2),
         s_servicos = round(servicos / total, digits = 2),
         s_adm = round(adm / total, digits=2)) %>% 
  filter(!is.na(uf))


tabela3  <- tabela2 %>%
  select(s_adm, s_agropecuaria, s_servicos, s_industria) %>% 
  summarise_all(funs(min = min, 
                      q25 = quantile(., 0.25), 
                      median = median, 
                      q75 = quantile(., 0.75), 
                      max = max,
                      mean = mean, 
                      sd = sd)) %>% 
  gather(stat, val) %>%
  separate(stat, into = c("s", "var", "stat"), sep = "_") %>%
  spread(stat, val) %>%
  select(var, min, q25, median, q75, max, mean, sd)


tabela3[,c(2:length(tabela3))] <- sapply(tabela3[,c(2:length(tabela3))], round, digits=2)

