package ;

import haxe.ui.data.ArrayDataSource;
import haxe.ui.events.UIEvent;
import sys.io.File;
import haxe.ui.containers.VBox;
import haxe.ui.components.DropDown;
import haxe.ui.events.MouseEvent;

@:build(haxe.ui.ComponentBuilder.build("assets/main-view.xml"))
class MainView extends VBox {
    var originalReactions:Array<MoviesReaction>;
    var changes:Array<MoviesReaction>;
    
    public function new() {
        super();
        
        var jsonString = File.getContent("assets/example.json");
        var reader = new json2object.JsonParser<Array<MoviesReaction>>();
        originalReactions = [];
        changes = [];

        try {
            reader.fromJson(jsonString);
            originalReactions = cast reader.value;
            
            var randNpc = Math.floor(Math.random() * originalReactions.length);
            var npc = originalReactions[randNpc];
            trace('${randNpc} (${npc.npcName})');
            var randReaction = Math.floor(Math.random() * npc.reactions.length);
            trace('${randReaction} (${npc.reactions[randReaction].id})');
            trace(npc.reactions[randReaction].specialResponses != null ? npc.reactions[randReaction].specialResponses.beforeMovie.text : "[nothing]");

            // characterDropdown.onChange = characterDropdown_onChange;
            // Add options to character dropdown
            for (r in originalReactions) {
                characterDropdown.dataSource.add(r.npcName);
            }
            // Add options to reaction tag dropdown
            var reactionTags = new ArrayDataSource<String>();
            reactionTags.add("Love");
            reactionTags.add("Like");
            reactionTags.add("Dislike");
            reactionTags.add("Seen (Love)");
            reactionTags.add("Seen (Like)");
            reactionTags.add("Seen (Dislike)");
            
            reactionResponseDropdown.dataSource = reactionTags;

        } catch (e) {
            trace(e.message);
            trace(e.details);
        }
        trace(reader.errors);
    }

    @:bind(characterDropdown, UIEvent.CHANGE)
    function characterDropdown_onChange(e:haxe.ui.events.UIEvent) {
        try {
            var charName:String = e.target.value;
            for (npc in originalReactions) {
                if (npc.npcName == charName) {
                    npcPortrait.resource = 'file://assets/images/portraits/portrait-${npc.npcName.toLowerCase()}.png';
                    // npcNameLabel.text = npc.npcName;

                    // Set up reactions
                    reactionDropdown.disabled = false;
                    reactionDropdown.dataSource.clear();
                    var source = new ArrayDataSource<String>();
                    trace("Character datasource data:");
                    for (react in npc.reactions) {
                        trace(react.id);
                        source.add('${react.tag} (${react.id})');
                    }
                    trace('Reaction dropdown data:');
                    reactionDropdown.dataSource = source;
                    for (i in 0...reactionDropdown.dataSource.size) {
                        trace(reactionDropdown.dataSource.get(i));
                    }
                    // Set a default entry so that the onChange event triggers for the reaction dropdown
                    reactionDropdown.selectedIndex = 0;
                    // reactionDropdown_onChange(new UIEvent(UIEvent.CHANGE,false,reactionDropdown.dataSource));

                    break;
                }
            }
        } catch (e) {
            trace('ERROR: ${e.message}');
            trace(e.details);
            npcPortrait.resource = 'file://assets/images/AnsweringMachine.png';
            // npcNameLabel.text = "ERROR!";
        }
    }

    @:bind(reactionDropdown, UIEvent.CHANGE)
    function reactionDropdown_onChange(e:haxe.ui.events.UIEvent) {
        var reactionID:String = e.target.value;
        var currentNPC:String = characterDropdown.value;
        // search for reaction
        for (npc in originalReactions) {
            if (npc.npcName == currentNPC) {
                var reactList = npc.reactions.filter((item) -> {
                    trace('${item.tag} (${item.id}) == ${reactionID}: ${'${item.tag} (${item.id}' == reactionID)}');
                    return ('${item.tag} (${item.id})' == reactionID);
                });
                if (reactList.length > 0) {
                    var r = reactList[0];
                    // we found the reaction, so enable editing controls
                    reactionResponseDropdown.disabled = false;
                    reactionResponseDropdown.selectedIndex = switch(r.response) {
                        case "love": 0;
                        case "like": 1;
                        case "dislike": 2;
                        case "seen_love": 3;
                        case "seen_like": 4;
                        case "seen_dislike": 5;
                        default: 0;
                    }

                    // Fill in reaction text, if it exists
                    if (r.specialResponses != null) {
                        if (r.specialResponses.beforeMovie != null) {
                            beforeMovieTab.disabled = false;
                            beforeMovieText.disabled = false;
                            beforeMovieText.text = r.specialResponses.beforeMovie.text;
                        } else {
                            beforeMovieTab.disabled = true;
                            beforeMovieText.disabled = true;
                            beforeMovieText.text = "";
                        }
                        if (r.specialResponses.duringMovie != null) {
                            duringMovieTab.disabled = false;
                            duringMovieText.disabled = false;
                            duringMovieText.text = r.specialResponses.duringMovie.text;
                        } else {
                            duringMovieTab.disabled = true;
                            duringMovieText.disabled = true;
                            duringMovieText.text = "";
                        }
                        if (r.specialResponses.afterMovie != null) {
                            afterMovieTab.disabled = false;
                            afterMovieText.disabled = false;
                            afterMovieText.text = r.specialResponses.afterMovie.text;
                        } else {
                            afterMovieTab.disabled = true;
                            afterMovieText.disabled = true;
                            afterMovieText.text = "";
                        }
                    } else {
                        // No special responses for this reaction, so disable text editing controls
                        beforeMovieTab.disabled = true;
                            beforeMovieText.disabled = true;
                            beforeMovieText.text = "";
                            duringMovieTab.disabled = true;
                            duringMovieText.disabled = true;
                            duringMovieText.text = "";
                            afterMovieTab.disabled = true;
                            afterMovieText.disabled = true;
                            afterMovieText.text = "";
                    }
                }
            }
            break;
        }
    }

    function writeFile() {
        // try {
        //     // test
        //     var randNpc = Math.floor(Math.random() * originalReactions.length);
        //     var npc = originalReactions[randNpc];
        //     trace('${randNpc} (${npc.npcName})');
        //     var randReaction = Math.floor(Math.random() * npc.reactions.length);
        //     trace('${randReaction} (${npc.reactions[randReaction].id})');
        //     trace(npc.reactions[randReaction].specialResponses != null ? npc.reactions[randReaction].specialResponses.beforeMovie.text : "[nothing]");

        //     var targetField:Array<String> = [];
        //     targetField.push(npc.npcName);
        //     targetField.push("Reactions");
        //     targetField.push('#${randReaction}');
        //     if (npc.reactions[randReaction].specialResponses != null) {
        //         targetField.push("SpecialResponses");
        //         targetField.push("BeforeMovie");
        //     }
        //     var patch:ListPatch = {changes: [{action:EDIT_DATA, target: "Data/MoviesReactions", targetField: targetField, entries: {text: "my replaced data"}}]};
        //     trace(patch);

        //     var writer = new json2object.JsonWriter<ListPatch>();
        //     var outputString = writer.write(patch,"  ");
        //     File.saveContent("output.json",outputString);
        // } catch (e) {
        //     trace(e.message);
        //     trace(e.details);
        // }
    }
    
}