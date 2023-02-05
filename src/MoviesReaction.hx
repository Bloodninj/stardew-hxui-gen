package;

typedef MoviesReaction = {
    @:alias("NPCName") public var npcName:String;
    @:alias("Reactions") public var reactions:Array<{
        @:alias("Tag") public var tag:String;
        @:alias("Response") public var response:String;
        @:alias("Whitelist") public var whitelist:Array<Null<String>>;
        
        @:alias("SpecialResponses") public var specialResponses:Null<{
            @:alias("BeforeMovie") public var beforeMovie:Null<{
                @:alias("ResponsePoint") public var responsePoint:String;
                @:alias("Script") public var script:String;
                @:alias("Text") public var text:String;
            }>;
            @:alias("DuringMovie") public var duringMovie:Null<{
                @:alias("ResponsePoint") public var responsePoint:String;
                @:alias("Script") public var script:String;
                @:alias("Text") public var text:String;
            }>;
            @:alias("AfterMovie") public var afterMovie:Null<{
                @:alias("ResponsePoint") public var responsePoint:String;
                @:alias("Script") public var script:String;
                @:alias("Text") public var text:String;
            }>;
        }>;
        @:alias("ID") public var id:String;
    }>;
}