﻿;#include <UIA> ; Uncomment if you have moved UIA.ahk to your main Lib folder
#include ..\Lib\UIA.ahk

cacheRequest := UIA.CreateCacheRequest()
; Set TreeScope to include the starting element and all descendants as well
cacheRequest.TreeScope := 5 
; Add all the necessary properties that DumpAll uses: ControlType, LocalizedControlType, AutomationId, Name, Value, ClassName, AcceleratorKey
cacheRequest.AddProperty("ControlType") 
cacheRequest.AddProperty("Name")
cacheRequest.AddProperty("Value")

cacheRequest.AddPattern("Value")
cacheRequest.AddProperty("ValueValue")

Run "notepad.exe"
WinWaitActive "ahk_exe notepad.exe"

MsgBox("Type something in Notepad: note that the document content won't change in the tooltip.`nPress F5 to refresh the cache - then the document content will also update in the tooltip.")

; Get element and also build the cache
npEl:= UIA.ElementFromHandle("ahk_exe notepad.exe", cacheRequest)
docEl := npEl.FindElement([{Type:"Document"}, {Type:"Edit"}],,,,cacheRequest)
; We now have a cached "snapshot" of the window from which we can access our desired elements faster.
Loop {
    ToolTip "Cached window name: " npEl.CachedName "`nCached document content: " docEl.CachedValue
}

F5::
{
    global npEl, docEl, cacheRequest
    npEl := npEl.BuildUpdatedCache(cacheRequest)
    docEl := docEl.BuildUpdatedCache(cacheRequest)
}
Esc::ExitApp