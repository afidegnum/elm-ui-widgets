module Widget.Style exposing (ButtonStyle, ColumnStyle, DialogStyle, ExpansionPanelStyle, RowStyle, SnackbarStyle, Style, TabStyle, TextInputStyle)

import Element exposing (Attribute, Element)
import Html exposing (Html)


type alias ButtonStyle msg =
    { container : List (Attribute msg)
    , labelRow : List (Attribute msg)
    , ifDisabled : List (Attribute msg)
    , ifActive : List (Attribute msg)
    }


type alias DialogStyle msg =
    { containerColumn : List (Attribute msg)
    , title : List (Attribute msg)
    , buttonRow : List (Attribute msg)
    , acceptButton : ButtonStyle msg
    , dismissButton : ButtonStyle msg
    }


type alias ExpansionPanelStyle msg =
    { containerColumn : List (Attribute msg)
    , panelRow : List (Attribute msg)
    , labelRow : List (Attribute msg)
    , content : List (Attribute msg)
    , expandIcon : Element Never
    , collapseIcon : Element Never
    }


type alias SnackbarStyle msg =
    { containerRow : List (Attribute msg)
    , text : List (Attribute msg)
    , button : ButtonStyle msg
    }


type alias TextInputStyle msg =
    { chipButton : ButtonStyle msg
    , containerRow : List (Attribute msg)
    , chipsRow : List (Attribute msg)
    , input : List (Attribute msg)
    }


type alias TabStyle msg =
    { button : ButtonStyle msg
    , optionRow : List (Attribute msg)
    , containerColumn : List (Attribute msg)
    , content : List (Attribute msg)
    }


type alias RowStyle msg =
    { containerRow : List (Attribute msg)
    , element : List (Attribute msg)
    , ifFirst : List (Attribute msg)
    , ifLast : List (Attribute msg)
    , ifCenter : List (Attribute msg)
    }


type alias ColumnStyle msg =
    { containerColumn : List (Attribute msg)
    , element : List (Attribute msg)
    , ifFirst : List (Attribute msg)
    , ifLast : List (Attribute msg)
    , ifCenter : List (Attribute msg)
    }


type alias Style style msg =
    { style
        | snackbar : SnackbarStyle msg
        , layout : List (Attribute msg) -> Element msg -> Html msg
        , header : List (Attribute msg)
        , sheet : List (Attribute msg)
        , sheetButton : ButtonStyle msg
        , menuButton : ButtonStyle msg
        , menuTabButton : ButtonStyle msg
        , menuIcon : Element Never
        , moreVerticalIcon : Element Never
        , spacing : Int
        , title : List (Attribute msg)
        , searchIcon : Element Never
        , search : List (Attribute msg)
        , searchFill : List (Attribute msg)
    }