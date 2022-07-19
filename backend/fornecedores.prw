#include 'protheus.ch'
#include 'restful.ch'

/*/{Protheus.doc} primeiroCRUD
      
    @type  Function
    @author CHQ
    @since 07/07/2022
/*/

WsRestful primeiroCRUD;
    Description "API para teste";
    Format "application/json"

    WsMethod GET todos ;
		Description "Listar todos os itens";
        WSSYNTAX "/todos";
		Path "/todos";
		Produces APPLICATION_JSON

    WsMethod GET fornecedor ;
		Description "Lista um item";
        WSSYNTAX "/fornecedor/";
		Path "/fornecedor/{codigo}/{loja}";
		Produces APPLICATION_JSON

End WsRestful


//-------------------------------------------------------------------
/*/{Protheus.doc} GET lista_todos

@author CHQ
/*/
//-------------------------------------------------------------------
WSMETHOD GET todos WSREST primeiroCRUD
	Local oJsonRet := JsonObject():New()
	Local oJsonError := JsonObject():New()
    Local bError:= { |e| oError:= e , BREAK(e) }
	
    Local cQuery := ""
    Local cNewAlias := GetNextAlias()
    Local aForn := {}

	::SetContentType("application/json")
    
    bErrorBlock:= ErrorBlock( bError )
    
    BEGIN SEQUENCE
        
        cQuery := " SELECT * "+CRLF
        cQuery += " FROM "+RetSqlName("SA2")+" SA2 "+CRLF
        cQuery += " WHERE SA2.D_E_L_E_T_ = ' ' "+CRLF
        cQuery += " AND SA2.A2_COD <= '000200' "+CRLF
        cQuery += " ORDER BY SA2.A2_COD "+CRLF
        
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),(cNewAlias), .F., .T.)

        While (cNewAlias)->(!Eof())
            oFornece := JsonObject():New()
            oFornece['codigo'] := (cNewAlias)->A2_COD
            oFornece['loja'] := (cNewAlias)->A2_LOJA
            
            aAdd(aForn,oFornece)

            (cNewAlias)->(dbSkip())
        EndDo
        
        DbSelectArea(cNewAlias)
        (cNewAlias)->(dbCloseArea())
        
        If Len(aForn) > 0
            oJsonRet['fornecedores'] := aForn
        
            If Len(aForn) == 1
                cMsg := "Foi encontrado 1 fornecedor"
            Else
                cMsg := "Foram encontrados "+cValToChar(Len(aForn))+" fornecedores"
            Endif

            oJsonRet['statusExecucao'] := Status(2,"INFO",cMsg)
        Else   
            cMsg := "Não foram encontrados fornecedores"
            oJsonRet['statusExecucao'] := Status(1,"INFO",cMsg)
        Endif
        ::SetResponse(EncodeUTF8(oJsonRet:toJson()))

    RECOVER
        
        oJsonError['statusExecucao'] := Status(0,"FATAL","Erro interno, "+oError:Description)
        ::SetResponse(EncodeUTF8(oJsonError:toJson()))

    END SEQUENCE
    
Return .T.



//-------------------------------------------------------------------
/*/{Protheus.doc} GET lista_um

@author CHQ
/*/
//-------------------------------------------------------------------

WSMETHOD GET fornecedor WSREST primeiroCRUD
    Local oJsonRet := JsonObject():New()
	Local oJsonError := JsonObject():New()
    Local bError:= { |e| oError:= e , BREAK(e) }

	::SetContentType("application/json")
    
    bErrorBlock:= ErrorBlock( bError )
    
    BEGIN SEQUENCE
        
        cFornece := ::aURLParms[2]
        cLoja := ::aURLParms[3]
        
        dbSelectArea("SA2")
        dbSetOrder(1)
        If dbSeek(xFilial("SA2")+cFornece)
            oDados := JsonObject():New()
            oDados["codigo"]     := Alltrim(SA2->A2_COD)
            oDados["loja"]       := Alltrim(SA2->A2_LOJA)
            oDados["tipo"]       := Alltrim(SA2->A2_TIPO)
            oDados["cgc"]        := Alltrim(SA2->A2_CGC)
            oDados["nome"]       := Alltrim(SA2->A2_NOME)
            oDados["nome_fant"]  := Alltrim(SA2->A2_NREDUZ)
            
            oJsonRet['dados'] := oDados
            oJsonRet['statusExecucao'] := Status(2,"INFO","Fornecedor encontrado")

            ::SetResponse(EncodeUTF8(oJsonRet:toJson()))

        Else

            oJsonRet['statusExecucao'] := Status(1,"ERRO","Fornecedor inválido")
            ::SetResponse(EncodeUTF8(oJsonRet:toJson()))
        EndIf
        
    RECOVER
        
        oJsonError['statusExecucao'] := Status(0,"FATAL","Erro interno, "+oError:Description)
        ::SetResponse(EncodeUTF8(oJsonError:toJson()))

    END SEQUENCE
Return .T.


Static Function Status(codigo,tipo,mensagem)
    Local aMensagens  := {}
    Local oMensagem := JsonObject():New()
    Local oMensagens := JsonObject():New()
    Local oStatusExecucao := JsonObject():New()
    
    oMensagem["codigo"] := codigo
    oMensagem["severidade"] := tipo
    oMensagem["mensagem"] := mensagem
    aAdd( aMensagens, oMensagem )

    oMensagens["mensagem"] :=aMensagens

    oStatusExecucao["executadoCorretamente"] := .T.
    oStatusExecucao["mensagens"] := oMensagens
Return oStatusExecucao
