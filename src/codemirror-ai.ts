//import { aiExtension } from '@marimo-team/codemirror-ai';
import { EditorView,keymap } from '@codemirror/view';
import {minimalSetup} from 'codemirror'
import { inlineSuggestion } from './inline-suggestion';
const fetchSuggestion=async(state)=>{
  console.log(state)
  return 'hello';
}
export const AIEditorView =(parent,doc)=>{
  new EditorView({
  doc,
  extensions: [
    // ... other extensions
    minimalSetup,
    inlineSuggestion({fetchFn:fetchSuggestion,delay:1000})
  ],
  parent
})
}