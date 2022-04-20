classDiagram
      
class authors {
    address
          au_fname
          au_id
          au_lname
          city
          contract
          phone
          state
          zip
          
}
        
class publishers {
    city
          country
          pub_id
          pub_name
          state
          
}
        
class titles {
    advance
          notes
          prequel_id
          price
          pub_id
          pubdate
          royalty
          title
          title_id
          type
          ytd_sales
          
}
        
class titleauthor {
    au_id
          au_ord
          royaltyper
          title_id
          
}
        
class stores {
    city
          state
          stor_address
          stor_id
          stor_name
          zip
          
}
        
class sales {
    ord_date
          ord_num
          payterms
          qty
          stor_id
          title_id
          
}
        
class roysched {
    hirange
          lorange
          royalty
          title_id
          
}
        
class discounts {
    discount
          discounttype
          highqty
          lowqty
          stor_id
          
}
        
class jobs {
    job_desc
          job_id
          max_lvl
          min_lvl
          
}
        
class pub_info {
    logo
          pr_info
          pub_id
          
}
        
class employee {
    emp_id
          fname
          hire_date
          job_id
          job_lvl
          lname
          minit
          pub_id
          
}
        
class Book {
    au_address
          au_city
          au_contract
          au_fname
          au_lname
          au_ord
          au_phone
          au_state
          au_zip
          book_advance
          book_notes
          book_price
          book_pubdate
          book_royalty
          book_title
          book_type
          book_ytd_sales
          created_by
          created_date
          prequel_id
          pub_city
          pub_country
          pub_id
          pub_name
          pub_state
          random_au_id
          random_title_id
          royalty_per
          
}
        
      titles --|> publishers: pub_id
            titleauthor --|> authors: au_id
            titleauthor --|> titles: title_id
            sales --|> stores: stor_id
            sales --|> titles: title_id
            roysched --|> titles: title_id
            discounts --|> stores: stor_id
            pub_info --|> publishers: pub_id
            employee --|> jobs: job_id
            employee --|> publishers: pub_id
            
      