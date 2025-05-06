@rem rebuild the front end
bun bundle.ts
cd dist
@rem add files to redbean archive
zip acc3.com .init.lua index.html global.css index.js index.css .lua\str.lua .lua\pitaka.lua .lua\zip.lua accelon3.png accelon3_512.png
acc3.com
cd ..
