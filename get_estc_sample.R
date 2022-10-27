load('../publisher_network/estc_actor_links')

load('../publisher_network/estc_core')

estc_hackathon = read_csv('../../estc_hackathon_edition/data_output/estc_student_edition.csv')


actor_links = estc_actor_links %>% 
  filter(actor_role_bookseller == TRUE | actor_role_publisher == TRUE | actor_role_printer == TRUE) %>% 
  left_join(estc_core %>% select(estc_id, publication_year)) %>% 
  filter(publication_year %in% 1700:1750) %>% 
  select(estc_id, actor_id)

load('../../r_projects/publisher_network/estc_actors')

actor_info = estc_actors %>% 
  filter(actor_id %in% actor_links$actor_id) %>% 
  select(actor_id, name_unified, year_birth, year_death)

book_info = estc_core %>% select(estc_id, publication_year, short_title, publication_place) %>% 
  left_join(estc_actor_links %>% filter(actor_role_author== TRUE) %>% 
              select(estc_id, author_id = actor_id, author_name_primary = actor_name_primary)) %>%
  filter(estc_id %in% actor_links$estc_id)


actor_links %>% write_csv('actor_links.csv')

actor_info %>% write_csv('actor_info.csv')

book_info %>% write_csv('book_info.csv')
