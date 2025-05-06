<script>
import { onMount} from 'svelte'
import {AIEditorView} from './codemirror-ai.ts'
let ele;
onMount(()=>AIEditorView(ele,"a\tbc"))

</script>
<div bind:this={ele}></div>
<style>
    :global(.cm-editor) {height:300px}
</style>