//////////////////////////////////////////////////////////////////////
//
//  DBEDIT.PRG
//
//  Copyright:
//      Alaska Software, (c) 1998-2003. All rights reserved.
//
//  Contents:
//      Compatiblity function DbEdit() to display databases (DBF files)
//
//////////////////////////////////////////////////////////////////////

#include "Inkey.ch"
#include "Appevent.ch"
#include "Dbedit.ch"

****************************************************************************
* Compatiblity function DbEdit()
****************************************************************************
PROCEDURE DbEdit( nTop      , ;        // Window coordinate: top
                  nLeft     , ;        // left
                  nBottom   , ;        // bottom
                  nRight    , ;        // right
                  aColumns  , ;        // Table columns
                  bcUserFunc, ;        // User function or code block
                  acPicture , ;        // PICTURE formats
                  acHeading , ;        // Column heading(s)
                  acHeadSep , ;        // Heading separator(s)
                  acColSep  , ;        // Column separator(s)
                  acFootSep , ;        // Footing separator(s)
                  acFooting   )        // Column footing(s)
LOCAL oTBColumn, i, imax, nKey, nMode, nExit, nCursor
LOCAL cHeadSepType, cColSepType, cFootSepType, cPictType, cFootingType
LOCAL nEvent, mp1, mp2, oXbp, lUseEvent

   nCursor := SetCursor(0)

   /*
    * No columns specified, display all fields
    */
   IF aColumns == NIL
      aColumns := DbStruct()
      AEval( aColumns, {|a| a := a[1] },,, .T. )
   ENDIF
   /*
    * Create TBrowse
    */
   oTbrowse         := TBrowseDB( nTop, nLeft, nBottom, nRight )
   oTBrowse:headSep := IIf( Valtype(acHeadSep)=="C", acHeadSep, "мям" )
   oTbrowse:colSep  := IIf( Valtype(acColSep) =="C", acColSep , " Ё " )

   /*
    * Same footing separator for all footings
    */
   IF Valtype( acFootSep ) == "C"

      oTBrowse:footSep := acFootSep
   ENDIF

   /*
    * Column headings must exist
    */
   IF acHeading == NIL
      acHeading := AClone( aColumns )
   /*
    * Same heading for all columns
    */
   ELSEIF Valtype( acHeading ) == "C"
      acHeading := AFill( Array( Len(aColumns) ), acHeading )
   ENDIF

   /*
    * A footing for all columns
    */
   IF Valtype( acFooting ) == "C"
      acFooting := AFill( Array( Len(aColumns) ), acFooting )
   ENDIF

   /*
    * Same PICTURE for all columns
    */
   IF Valtype( acPicture ) == "C"
      acPicture := AFill( Array( Len(aColumns) ), acPicture )
   ENDIF

   imax         := Len( aColumns )
   cHeadSepType := Valtype( acHeadSep )
   cColSepType  := Valtype( acColSep )
   cFootSepType := Valtype( acFootSep )
   cPictType    := Valtype( acPicture )
   cFootingType := Valtype( acFooting )

   /*
    * Create TBColumn objects
    */
   FOR i:=1 TO imax
      IF Type( aColumns[i] ) == "M"
         oTBColumn := TBColumnNew( acHeading[i], {|| "  <Memo>  "} )
      ELSE
         oTBColumn := TBColumnNew( acHeading[i], &("{||"+aColumns[i]+"}"))
      ENDIF

      IF  cHeadSepType == "A"
         oTBColumn:headSep := acHeadSep[i]
      ENDIF

      IF cColSepType == "A"
         oTBColumn:colSep := acColSep[i]
      ENDIF

      IF cFootSepType == "A"
         oTBColumn:footSep := acFootSep[i]
      ENDIF

      IF cFootingType == "A"
         oTBColumn:footing := acFooting[i]
      ENDIF

      IF cPictType == "A"
         oTBColumn:picture := acPicture[i]
      ENDIF

      /*
       * Add column to Tbrowse
       */
      oTBrowse:addColumn( oTBColumn )
   NEXT

   /*
    * Compile user function to code block
    */
   IF Valtype( bcUserFunc ) == "C"
      bcUserFunc := &("{|nMode,nColPos|"+bcUserFunc+"(nMode,nColPos) }")
   ELSEIF Valtype( bcUserFunc ) <> "B"
      /*
       * Set user function codeblock to NIL (for compatibility reasons)
       */
      bcUserFunc := NIL
   ENDIF

   nMode     := DE_IDLE
   nExit     := DE_CONT
   lUseEvent := SetMouse()

   DO WHILE nExit <> DE_ABORT

      /*
       * Incremental display ...
       */
      DO WHILE ! oTBrowse:stabilize()
         IF lUseEvent
            IF (nEvent := NextAppEvent( @mp1, @mp2, @oXbp )) > xbe_None .AND. ;
               (nEvent <> xbeM_Motion )
               nEvent := AppEvent( @mp1, @mp2, @oXbp )
               EXIT
            ENDIF
         ELSE
            /*
             * ... is interrupted by a key press
             */
            IF (nKey := InKey()) <> 0
               EXIT
            ENDIF
         ENDIF
      ENDDO

      /*
       * TBrowse is stable
       */
      IF oTBrowse:stable
         IF bcUserFunc <> NIL
            /*
             * Set DbEdit modes
             */
            DO CASE
            CASE LastRec() == 0 .AND. nMode != DE_EXCEPT
               nMode := DE_EMPTY
            CASE nMode == DE_EXCEPT
            CASE oTBrowse:hitTop
               nMode := DE_HITTOP
            CASE oTBrowse:hitBottom
               nMode := DE_HITBOTTOM
            ENDCASE
            /*
             * Execute User function
             */
            nExit := Eval( bcUserFunc, nMode, oTbrowse:colPos )
            IF Valtype( nExit ) <> "N"
               nExit := DE_CONT
            ENDIF

            /*
             * Return value of User function
             */
            IF nExit == DE_REFRESH
               oTBrowse:refreshAll()
               nExit := DE_CONT
               nMode := DE_IDLE
               LOOP
            ELSEIF nExit == DE_CONT
               oTBrowse:refreshCurrent()
               oTBrowse:forceStable()
            ELSEIF nExit == DE_ABORT
               EXIT
            ENDIF
         ENDIF

         nMode := DE_IDLE
         nExit := DE_CONT
         /*
          * Get next event
          */
         IF lUseEvent
            /*
             * "Mouse motion" is ignored
             */
            nEvent := xbeM_Motion
            DO WHILE nEvent == xbeM_Motion
               nEvent := AppEvent( @mp1, @mp2, @oXbp, 0 )
               IF nEvent == xbeM_Motion .AND. Set( _SET_HANDLEEVENT )
                  oXbp:HandleEvent( nEvent, mp1, mp2 )
               ENDIF
            ENDDO
         ELSE
            /*
             * Wait for a key press
             */
            nKey   := InKey(0)
         ENDIF
      ENDIF

      IF lUseEvent
         nKey := 0
         IF nEvent == xbeM_LbDown
            IF TBHandleEvent( oTBrowse, nEvent, mp1, mp2, oXbp ) <> 0
               nMode := DE_IDLE
            ENDIF
            /*
             * Key was pressed
             */
         ELSEIF nEvent < xbeB_Event
            DO CASE
            CASE nEvent == 0
            CASE nEvent == K_ENTER .OR. nEvent == K_ESC
                IF bcUserFunc == NIL
                   nExit := DE_ABORT
                ELSE
                   nMode := DE_EXCEPT
                ENDIF
            CASE TBHandleEvent( oTBrowse, nEvent, mp1, mp2, oXbp ) > 0
            OTHERWISE
                nMode := DE_EXCEPT
            ENDCASE
         ELSE
            /*
             * Handle unknown event
             */
            TBHandleEvent( oTBrowse, nEvent, mp1, mp2, oXbp )
            nMode := DE_EXCEPT
         ENDIF
      ELSE
         /*
          * Process key
          */
         DO CASE
         CASE nKey == 0
         CASE nKey == K_ENTER .OR. nKey == K_ESC
            IF bcUserFunc == NIL
               nExit := DE_ABORT
            ELSE
               nMode := DE_EXCEPT
            ENDIF
         CASE TBApplyKey( oTBrowse, nKey ) > 0
         OTHERWISE
            nMode := DE_EXCEPT
         ENDCASE
      ENDIF
   ENDDO

   SetCursor(nCursor)

RETURN




