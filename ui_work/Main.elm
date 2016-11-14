
port module Main exposing (..)


import Html.App as App
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Material
import Material.Options as Options exposing (when, nop)
import Material.Options exposing (css)
import Material.Table as Table
import Set exposing (Set)
import Material.Toggles as Toggles
import Material.Button as Button exposing (..)
import Material.Icon as Icon
import Platform.Cmd exposing (..)
import Material.Card as Card
import Material.Color as Color
import Material.Options as Options exposing (..)
import Material.List as Lists exposing (..)
import Material.Textfield as Textfield 
-- import Material.Scheme
-- import Json.Decode exposing (Decoder, int, string, list, at, object3, (:=))
import String
import Form exposing (..)
import Form.Validate as Validate exposing (..)
import Form.Input as Input

import Dict

port input : (Int -> msg) -> Sub msg

type alias Model =
    { mdl : Material.Model
    , selected : Set String
    , entries : List Data
    , forms : Form () Data
    }

type alias Data =
    { pertype : String
    , name : String
    , title : String
    , phone: String
    , fax: String
    , email: String
    
    }


model =
    { mdl = Material.model
    , selected = Set.empty
    , entries = [] ++ datas
    , forms = Form.initial [] validate
    }


data = Data "" "" "" "" "" "" 

datas =
    [ { pertype = "Executive"
        , name = "Srikanth"
        , title = "CEO"
        , phone = "988889999"
        , fax = "8822"
        , email = "pykanth@gmail.com"
        
        }
    , { pertype = "Executive1"
        , name = "Pradeep"
        , title = "CTO"
        , phone = "988889999"
        , fax = "8822"
        , email = "pradeep@gmail.com"
        
        }
    , { pertype = "Executive2"
        , name = "Praveen"
        , title = "CFO"
        , phone = "988889999"
        , fax = "8822"
        , email = "praveen@gmail.com"
        
        }
    ]


toggle : comparable -> Set comparable -> Set comparable
toggle x set =
    if Set.member x set then
        Set.remove x set
    else
        Set.insert x set

type Msg
    = Mdl (Material.Msg Msg)
    | Toggle String
    | Add
    | Delete
    | FormMsg Form.Msg
   
    

allSelected : { c | entries : List a, selected : Set b } -> Bool
allSelected model =
    Set.size model.selected == List.length model.entries


key =
    .email


-- update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of

        Toggle idx ->

            { model | selected = toggle idx  model.selected }
            ![]

        Mdl msg ->
            Material.update msg model

        Add ->
            { model
                    | entries = model.entries ++  []
                
                }
                ![]

        Delete ->
            let
                updatedEntries = List.filter (\x -> not  (List.member  x.email (Set.toList model.selected))) model.entries
            in
                { model |  entries = updatedEntries
                        , selected = Set.empty }
                ![]

        FormMsg formMsg ->
               ({ model | forms = 
                            Form.update formMsg model.forms
                        -- , entries  = List.append (model.forms) model.entries 
               }, Cmd.none)
               



validate : Validation () Data
validate =
  form6 Data
    (get "name" string)
    (get "title" string)
    (get "email" email)
    (get "fax" string)
    (get "phone" string)
    (get "pertype" string)
    
    


formView : Form () Data -> Html Form.Msg
formView form =
  let
    errorFor field =
      case field.liveError of
        Just error ->
          Html.div [ class "error" ] [ text (toString error) ]
        Nothing ->
          text ""

    -- fields states
    name = Form.getFieldAsString "name" form
    title = Form.getFieldAsString"title" form
    pertype = Form.getFieldAsString "pertype" form
    email = Form.getFieldAsString "email" form
    fax = Form.getFieldAsString "fax" form
    phone = Form.getFieldAsString "phone" form
    
    
  in
    Html.div []
      [ label [] [ text "name" ]
      , Input.textInput name []
      , errorFor name

      , label []
          [ Input.textInput title []
          , text "title"
          ]
      , errorFor title

      , label []
          [ Input.textInput email []
          , text "email"
          ]
      , errorFor email

      , label []
            [ Input.textInput phone []
            , text "phone"
            ]
        , errorFor phone
      , label []
            [ Input.textInput fax []
            , text "fax"
            ]
        , errorFor fax
      , label []
             [ Input.textInput pertype []
            , text "pertype"
            ]
        , errorFor pertype
        , button
          [ Html.Events.onClick Form.Submit ]
          [ text "Submit" ]
        
      ]

         

view: Model-> Html Msg
view model =
    let
        formview = 
            App.map FormMsg (formView model.forms)

        table1 =
            Table.table []
                [ Table.thead []
                    [ Table.tr []
                        [ Table.th []
                            [
                            ]
                        , Table.th [] [ text "Type" ]
                        , Table.th [] [ text "Name" ]
                        , Table.th [] [ text "Title" ]
                        , Table.th [] [ text "Phone" ]
                        , Table.th [] [ text "Fax" ]
                        , Table.th [] [ text "Email" ]
                        ]
                    ]
                , Table.tbody []
                    ( model.entries
                    |> List.indexedMap (\idx item ->
                        Table.tr
                            [ Table.selected `when` Set.member (key item) model.selected ]
                            [ Table.td []
                            [ Toggles.checkbox Mdl [idx] model.mdl
                                [ Toggles.onClick (Toggle <| key item)
                                , Toggles.value <| Set.member (key item) model.selected
                                ] []
                            ]
                            , Table.td [] [ text item.pertype ]
                            , Table.td [] [ text item.name ]
                            , Table.td [] [ text item.title ]
                            , Table.td [] [ text item.phone ]
                            , Table.td [] [ text item.fax ]
                            , Table.td [] [ text item.email]

                            -- , Table.td [] [text (toString  model.forms)]
                            ]
                        )
                    )
                ]
    
        table = Html.div [] [
                    Table.tbody[] ( model.entries
                        |> List.indexedMap (\idx item ->
                            Lists.ul []
                                [ Lists.li []
                                    [ Lists.content [] 
                                        [ Lists.avatarIcon "photo_camera" []
                                        , text item.name
                                        -- , text (toString  data)
                                        , Lists.subtitle [] [ Html.a [ href (String.concat ["tel:" , (toString item.phone)])]  [ Icon.i "phone"] ] 
                                        ]
                                        , Lists.content2 [] 
                                            [ Toggles.checkbox Mdl [4] model.mdl
                                                [ Toggles.value (Set.member (key item) model.selected) 
                                                , Toggles.onClick (Toggle <| key item)
                                                ] 
                                                []
                                            ]
                                        ]
                                
                                    ]
                                )
                        )
                 ]
            
       
            --  Card.view
            --         [css "width" "25%"
            --         , css "padding" "16px"
            --         , css "float" "center"
            --         , Color.background (Color.color Color.Grey Color.S400)
            --         , css "margin" "4px 8px 4px 0px"]
            --         [ Card.title
            --             [ css "flex-direction" "column" ]
            --             [ Card.head [ ] [
            --                 text "Add Contact"
            --                 ]
            --             , Options.div 
            --                         [ css "padding" "2rem 2rem 0 2rem" ]
            --                         [ Textfield.render Mdl [2] model.mdl
            --                             [ Textfield.label "Name "
            --                             , Textfield.floatingLabel
            --                             , Textfield.text' 
            --                              ] ]
            --             ]
            --         ]
    in
        Html.div [] [
            table
            , if  Set.size model.selected >= 1 then
                        Button.render Mdl [0] model.mdl
                            [ Button.fab
                            , (css "align" "center")
                            , Button.colored
                            , Button.onClick Delete
                            ]
                            [ Icon.i "delete"]

            else 
                Html.div [] [ formview ]
                    
            
        ]
    
                 
            -- |> Material.Scheme.top


main : Program Never
main =
  App.program
    { init = (model, Cmd.none)
    , view = view
    , subscriptions = always Sub.none
    , update = update
    }