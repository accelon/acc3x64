<script>
// import Codemirror from "./codemirror.svelte";
import {openPtk} from 'ptk'
import {onMount} from 'svelte'
let content=$state('')
onMount(async ()=>{
    let ptk=await openPtk("cs-xsq");
    console.log(ptk)

    ptk=await openPtk("cs-ccc");
    console.log(ptk)
})
const onclick=async ()=>{
    
}
</script>
<div class="app">
    <span class="message">{content}</span>
    <button {onclick}>get</button>
</div>
<style>
    .app {color:white;height:95vh;background-color: #1f1f1f;} /* splitpane divider need this */
    .message {font-size:100%}
</style>