module Stateless exposing (Model, Msg, init, update, view)

import Array exposing (Array)
import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Framework.Button as Button
import Framework.Card as Card
import Framework.Color as Color
import Framework.Grid as Grid
import Framework.Group as Group
import Framework.Heading as Heading
import Framework.Input as Input
import Framework.Tag as Tag
import Heroicons.Solid as Heroicons
import Html exposing (Html)
import Html.Attributes as Attributes
import Set exposing (Set)
import Widget.Button as Button exposing (ButtonStyle)
import Layout exposing (Part(..))
import Icons
import Widget

buttonStyle : ButtonStyle msg
buttonStyle =
    { label = [ Element.spacing 8]
    , container = Button.simple
    , disabled = Color.disabled
    , active = Color.primary
    }

tabButtonStyle :ButtonStyle msg
tabButtonStyle=
    { label = [ Element.spacing 8]
    , container = Button.simple ++ Group.top
    , disabled = Color.disabled
    , active = Color.primary
    }

type alias Model =
    { selected : Maybe Int
    , multiSelected : Set Int
    , isCollapsed : Bool
    , carousel : Int
    , tab : Maybe Int
    , button : Bool
    }


type Msg
    = ChangedSelected Int
    | ChangedMultiSelected Int
    | ToggleCollapsable Bool
    | ChangedTab Int
    | SetCarousel Int
    | ToggleButton Bool


init : Model
init =
    { selected = Nothing
    , multiSelected = Set.empty
    , isCollapsed = False
    , carousel = 0
    , tab = Just 1
    , button = True
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangedSelected int ->
            ( { model
                | selected = Just int
              }
            , Cmd.none
            )

        ChangedMultiSelected int ->
            ( { model
                | multiSelected =
                    model.multiSelected
                        |> (if model.multiSelected |> Set.member int then
                                Set.remove int

                            else
                                Set.insert int
                           )
              }
            , Cmd.none
            )

        ToggleCollapsable bool ->
            ( { model
                | isCollapsed = bool
              }
            , Cmd.none
            )

        SetCarousel int ->
            ( if (int < 0) || (int > 3) then
                model

              else
                { model
                    | carousel = int
                }
            , Cmd.none
            )

        ChangedTab int ->
            ( { model | tab = Just int }, Cmd.none )
        
        ToggleButton bool ->
            ( { model | button = bool }, Cmd.none )


select : Model -> (String,Element Msg)
select model =
    ( "Select"
    , { selected = model.selected
      , options = 
        [ 1, 2, 42 ]
        |> List.map (\int ->
            { text = String.fromInt int
            , icon = Element.none
            }
        )
      , onSelect = ChangedSelected >> Just
      }
        |> Widget.select
        |> List.indexedMap
            (\i ->
                Widget.selectButton
                    { buttonStyle
                    | container = buttonStyle.container
                        ++ (if i == 0 then
                                Group.left

                            else if i == 2 then
                                Group.right

                            else
                                Group.center
                           )
                    }
            )
        
        |> Element.row Grid.compact
    )


multiSelect : Model -> (String,Element Msg)
multiSelect model =
    ( "Multi Select"
    , { selected = model.multiSelected
      , options = 
        [ 1, 2, 42 ]
        |> List.map (\int -> 
            { text = String.fromInt int
            , icon = Element.none
            })
      , onSelect = ChangedMultiSelected >> Just
      }
        |> Widget.multiSelect
        |> List.indexedMap
            (\i ->
                Widget.selectButton
                    { buttonStyle
                    | container = buttonStyle.container
                        ++ (if i == 0 then
                                Group.left

                            else if i == 2 then
                                Group.right

                            else
                                Group.center
                           )
                    }
            )
        |> Element.row Grid.compact
    )

collapsable : Model -> (String,Element Msg)
collapsable model =
    ( "Collapsable"
    , Widget.collapsable
        { onToggle = ToggleCollapsable
        , isCollapsed = model.isCollapsed
        , label =
            Element.row Grid.compact
                [ Element.html <|
                    if model.isCollapsed then
                        Heroicons.cheveronRight [ Attributes.width 20 ]

                    else
                        Heroicons.cheveronDown [ Attributes.width 20 ]
                , Element.el Heading.h4 <| Element.text <| "Title"
                ]
        , content = Element.text <| "Hello World"
        }
    )

tab : Model -> (String,Element Msg)
tab model =
    ( "Tab"
    , Widget.tab 
            { tabButton = tabButtonStyle
            , tabRow = Grid.simple
            } 
            { selected = model.tab
            , options = [ 1, 2, 3 ]
                |> List.map (\int ->
                    { text = "Tab " ++ (int |> String.fromInt)
                    , icon = Element.none
                    }
                )
            , onSelect = ChangedTab >> Just
            } <|
            (\selected ->
                (case selected of
                    Just 0 ->
                        "This is Tab 1"

                    Just 1 ->
                        "This is the second tab"

                    Just 2 ->
                        "The thrid and last tab"

                    _ ->
                        "Please select a tab"
                )
                    |> Element.text
                    |> Element.el (Card.small ++ Group.bottom)
            )
    )

modal : (Maybe Part -> msg) -> Model -> (String,Element msg)
modal changedSheet model =
    ( "Modal"
    ,   [ Input.button Button.simple
            { onPress = Just <| changedSheet <| Just LeftSheet
            , label = Element.text <| "show left sheet"
            }
        ,  Input.button Button.simple
            { onPress = Just <| changedSheet <| Just RightSheet
            , label = Element.text <| "show right sheet"
            }
        ] |> Element.column Grid.simple
    )
    
dialog : msg -> Model -> (String,Element msg)
dialog showDialog model =
    ( "Dialog"
    , Input.button Button.simple
        { onPress = Just showDialog
        , label = Element.text <| "Show dialog"
        }
    )

carousel : Model -> (String,Element Msg)
carousel model =
    ( "Carousel"
    , Widget.carousel
        { content = ( Color.cyan, [ Color.yellow, Color.green, Color.red ] |> Array.fromList )
        , current = model.carousel
        , label =
            \c ->
                [ Input.button [ Element.centerY ]
                    { onPress = Just <| SetCarousel <| model.carousel - 1
                    , label =
                        Heroicons.cheveronLeft [ Attributes.width 20 ]
                            |> Element.html
                    }
                , Element.el
                    (Card.simple
                        ++ [ Background.color <| c
                           , Element.height <| Element.px <| 100
                           , Element.width <| Element.px <| 100
                           ]
                    )
                  <|
                    Element.none
                , Input.button [ Element.centerY ]
                    { onPress = Just <| SetCarousel <| model.carousel + 1
                    , label =
                        Heroicons.cheveronRight [ Attributes.width 20 ]
                            |> Element.html
                    }
                ]
                    |> Element.row (Grid.simple ++ [ Element.centerX, Element.width <| Element.shrink ])
        }
    )

iconButton : Model -> (String,Element Msg)
iconButton model =
    ( "Icon Button"
    , [Button.view buttonStyle
        { text = "disable me"
        , icon = Icons.slash |> Element.html |> Element.el []        , onPress =
            if model.button then
                Just <| ToggleButton False
            else
                Nothing
        }
    , Button.view buttonStyle
        { text = "reset button"
        , icon = Element.none       
        , onPress =  Just <| ToggleButton True
        }
    ] |> Element.column Grid.simple
    )

view : 
    { msgMapper : Msg -> msg
    , showDialog : msg
    , changedSheet : Maybe Part -> msg
    } -> Model 
     -> { title : String
        , description : String
        , items : List (String,Element msg)
        }
view { msgMapper, showDialog, changedSheet } model =
    { title = "Stateless Views"
    , description = "Stateless views are simple functions that view some content. No wiring required."
    , items =
        [ iconButton model  |> Tuple.mapSecond (Element.map msgMapper)
        , select model |> Tuple.mapSecond (Element.map msgMapper)
        , multiSelect model |> Tuple.mapSecond (Element.map msgMapper)
        , collapsable model |> Tuple.mapSecond (Element.map msgMapper)
        , modal changedSheet model
        , carousel model |> Tuple.mapSecond (Element.map msgMapper)
        , tab model |> Tuple.mapSecond (Element.map msgMapper)
        , dialog showDialog model
        ]
    }
