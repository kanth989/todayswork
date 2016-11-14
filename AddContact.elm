
adddataview model = 
    let 
     
        side_card = 
             Card.view
                    [css "width" "25%"
                    , css "padding" "16px"
                    , css "float" "center"
                    , Color.background (Color.color Color.Grey Color.S400)
                    , css "margin" "4px 8px 4px 0px"]
                    [ Card.title
                        [ css "flex-direction" "column" ]
                        [ Card.head [ ] [
                            text "Add Contact"
                            ]
                        , Options.div
                                    [ css "padding" "2rem 2rem 0 2rem" ]
                                    [ Textfield.render Mdl [2] model.mdl
                                        [ Textfield.label "Floating label"
                                        , Textfield.floatingLabel
                                        , Textfield.text'
                                        ] ]
                        ]
                    ]
        in 
            side_card


type alias Data =
    { pertype : String
    , name : String
    , title : String
    , phone: String
    , fax: String
    , email: String
    , ids : Int
    }


type Dmsg =
    Pertype String
    | Title String
    | Name String 
    | Email String 
    | Phone String 
    | Fax String 
    | Ids Int
    


updateform : Dmsg -> Data -> Data
updateform msg model =
  case msg of
    Name name ->
      { model | name = name }

    Title title ->
      { model | title = title }

    Email email ->
      { model | email = email }
      
    
    Fax fax ->
      { model | fax = fax }
      
    Phone phone ->
      { model | phone = phone }
      
    Pertype pertype ->
      { model | pertype = pertype }
     
     
    Ids ids ->
      { model | ids = ids }
