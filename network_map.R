mp_data <- read.csv("LegislationMPs_sampledata.csv")
amend_data <- read.csv("Legislation_sampledata.csv")

amend_data <- amend_data %>% select(BillID,AmmendmentID,TabledBy) %>% unite(ID, c("BillID", "AmmendmentID")) %>% 
  mutate(splitTB = strsplit(TabledBy, "; ")) %>% unnest(splitTB) %>% select(-"TabledBy")
mp_data <- mp_data %>% select(Name, Party) %>% distinct()

matrix <- crossprod(table(amend_data[1:2]))
diag(matrix) <- 0
matrix <- as.data.frame(matrix)

va <- matrix %>%
  dplyr::mutate(Persona = rownames(.),
                Occurrences = rowSums(.)) %>%
  dplyr::select(Persona, Occurrences)

ed <- matrix %>%
  dplyr::mutate(from = rownames(.)) %>%
  tidyr::gather(to, Frequency, "Baroness Billingham":"Lord Bellamy") %>%
  dplyr::mutate(Frequency = ifelse(Frequency == 0, NA, Frequency))

ig <- igraph::graph_from_data_frame(d=ed, vertices=va, directed = FALSE)
  
tg <- tidygraph::as_tbl_graph(ig) %>% 
  tidygraph::activate(nodes) %>% 
  dplyr::mutate(label=name)
  
set.seed(12345)
E(tg)$weight <- E(tg)$Frequency
v.size <- V(tg)$Occurrences

# edge size shows frequency of co-occurrence
tg %>%
  ggraph(layout = "fr") +
  geom_edge_arc(colour= "gray50",
                lineend = "round",
                strength = .1,
                aes(edge_width = weight,
                    alpha = weight)) +
  geom_node_point(size=log(v.size)*5, 
                  aes(color=dummy_mp$party)) +
  labs(color = "Party") +
  geom_node_text(aes(label = name), 
                 repel = TRUE, 
                 point.padding = unit(0.2, "lines"), 
                 size=sqrt(v.size)*2, 
                 colour="gray10") +
  scale_edge_width(range = c(0, 2.5)) +
  scale_edge_alpha(range = c(0, .3)) +
  theme_graph(background = "white") +
  theme(legend.position = "top") +
  guides(edge_width = "none",
         edge_alpha = "none")
