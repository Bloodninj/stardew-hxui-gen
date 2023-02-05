package ;

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

            characterDropdown.onChange = characterDropdown_onChange;
            for (r in originalReactions) {
                characterDropdown.dataSource.add(r.npcName);
            }

        } catch (e) {
            trace(e.message);
            trace(e.details);
        }
        trace(reader.errors);
    }

    function characterDropdown_onChange(e:UIEvent):Void {
        try {
            var charName:String = e.target.value;
            for (r in originalReactions) {
                if (r.npcName == charName) {
                    npcPortrait.resource = 'file://assets/images/portraits/portrait-${r.npcName.toLowerCase()}.png';
                    // npcNameLabel.text = r.npcName;

                    // Set up reactions
                    reactionDropdown.disabled = false;
                    reactionDropdown.dataSource.clear();
                    for (react in r.reactions) {
                        trace(react.id);
                        reactionDropdown.dataSource.add(react.id);
                    }
                    trace('Data:');
                    for (i in 0...reactionDropdown.dataSource.size) {
                        trace(reactionDropdown.dataSource.get(i));
                    }
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