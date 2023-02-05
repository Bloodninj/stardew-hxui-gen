package;

enum abstract PatchActions(String) from String to String {
    var EDIT_DATA = "EditData";
    var EDIT_IMAGE = "EditImage";
}

typedef ListPatch = {
    @:alias("Changes") var changes:Array<{
        @:alias("Action") var action:PatchActions;
        @:alias("Target") var target:String;
        @:alias("TargetField") var targetField:Array<String>;
        @:alias("Entries") var entries:{
            @:alias("Text") var text:String;
        };
    }>;
}