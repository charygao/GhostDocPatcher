Installation:

run inject.bat to:

 1. rename original "hhc.exe" to "hhc.bak.exe" (located in "C:\Program Files (x86)\HTML Help Workshop")
 2. copy our "hhc.exe" to "C:\Program Files (x86)\HTML Help Workshop" folder

How it works?

GhostDoc (Pro or Enterprise) generates in some temporary folder the HTML files used for CHM file compilation.
The compilation is actually done by the "HTML Help Workshop" (hhc.exe) that is included with Windows.
After the compilation of CHM, the GhostDoc removes the temporary folder.

Our tool is made to intercept the call from GhostDoc to hhc.exe so it could find out the exact temporary location of the HTML files and to remove all watermark text from it before calling the actual HHC compiler (now called "hhc.bak.exe").

Files included:
hhc.exe - our tool
inject.bat - script to easily copy the hhc.exe
hhc.bak.exe - original HHC compiler renamed to "hhc.bak.exe" (included just in case)






