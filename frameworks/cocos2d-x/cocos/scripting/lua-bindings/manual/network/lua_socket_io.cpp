#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 || CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
#include "lua_socket_io.h"
#include <map>
#include <string>
#include "tolua_fix.h"
#include "cocos2d.h"
#include "CCLuaStack.h"
#include "CCLuaValue.h"
#include "CCLuaEngine.h"
#include "LuaScriptHandlerMgr.h"

using namespace cocos2d;

static int SendBinaryMessageToLua(int handler,const unsigned char* pTable,int nLength)
{
    if (NULL == pTable || handler <= 0) {
        return 0;
    }
    
    if (NULL == ScriptEngineManager::getInstance()->getScriptEngine()) {
        return 0;
    }
    
    LuaStack *pStack = LuaEngine::getInstance()->getLuaStack();
    if (NULL == pStack) {
        return 0;
    }
    
    lua_State *tolua_s = pStack->getLuaState();
    if (NULL == tolua_s) {
        return 0;
    }
    
    int nRet = 0;
    LuaValueArray array;
    for (int i = 0 ; i < nLength; i++) {
        LuaValue value = LuaValue::intValue(pTable[i]);
        array.push_back(value);
    }
    
    pStack->pushLuaValueArray(array);
    nRet = pStack->executeFunctionByHandler(handler, 1);
    pStack->clean();
    return nRet;
}



LuaSIOClient::LuaSIOClient()
{
    printf("LuaSIOClient constructor\n");
}

void LuaSIOClient::setClient(cocos2d::network::SIOClient* client)
{
    _client = client;
}

LuaSIOClient::~LuaSIOClient()
{
    _client->setDelegate(nullptr);
    ScriptHandlerMgr::getInstance()->removeObjectAllHandlers((void*)this);
    printf("LuaSIOClient destructor\n");
}

void LuaSIOClient::send(std::string& message)
{
    _client->send(message);
}
void LuaSIOClient::emit(std::string& event, std::string& args)
{
    _client->emit(event, args);
}
void LuaSIOClient::disconnect()
{
    _client->disconnect();
    _client = nullptr;
}

void LuaSIOClient::onConnect(cocos2d::network::SIOClient* client)
{
//    CCLOG("LuaSIOClient::onConnect\n");
//    LuaSIOClient* luaSc = dynamic_cast<LuaSIOClient*>(client);
//    if (NULL != luaSc) {
        int handler = ScriptHandlerMgr::getInstance()->getObjectHandler((void*)this,ScriptHandlerMgr::HandlerType::WEBSOCKET_OPEN);
//        CCLOG("handler = %d type = %d\n", handler, (int)ScriptHandlerMgr::HandlerType::WEBSOCKET_OPEN);
        if (0 != handler) {
            CommonScriptData data(handler,"");
            ScriptEvent event(kCommonEvent,(void*)&data);
            ScriptEngineManager::getInstance()->getScriptEngine()->sendEvent(&event);
        }
//    }
}

void LuaSIOClient::onMessage(cocos2d::network::SIOClient* client, const std::string& data)
{
//    CCLOG("LuaSIOClient::onMessage\n");
//    LuaSIOClient* luaSc = dynamic_cast<LuaSIOClient*>(client);
//    if (NULL != luaSc) {
        int handler = ScriptHandlerMgr::getInstance()->getObjectHandler((void*)this,ScriptHandlerMgr::HandlerType::WEBSOCKET_MESSAGE);
//        CCLOG("handler = %d type = %d\n", handler, (int)ScriptHandlerMgr::HandlerType::WEBSOCKET_MESSAGE);
        if (0 != handler)
        {
            LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
            if (nullptr != stack)
            {
                stack->pushString(data.c_str(),(int)data.length());
                stack->executeFunctionByHandler(handler,  1);
            }
        }
//    }
}

void LuaSIOClient::onClose(cocos2d::network::SIOClient* client)
{
//    CCLOG("LuaSIOClient::onClose\n");
//    LuaSIOClient* luaSc = dynamic_cast<LuaSIOClient*>(client);
//    if (NULL != luaSc) {
        int handler = ScriptHandlerMgr::getInstance()->getObjectHandler((void*)this,ScriptHandlerMgr::HandlerType::WEBSOCKET_CLOSE);
//        CCLOG("handler = %d type = %d\n", handler, (int)ScriptHandlerMgr::HandlerType::WEBSOCKET_CLOSE);
        if (0 != handler)
        {
            CommonScriptData data(handler,"");
            ScriptEvent event(kCommonEvent,(void*)&data);
            ScriptEngineManager::getInstance()->getScriptEngine()->sendEvent(&event);
        }
//    }
}

void LuaSIOClient::onError(cocos2d::network::SIOClient* client, const std::string& error)
{
//    CCLOG("LuaSIOClient::onError\n");
//    LuaSIOClient* luaSc = dynamic_cast<LuaSIOClient*>(client);
//    if (NULL != luaSc) {
        int handler = ScriptHandlerMgr::getInstance()->getObjectHandler((void*)this,ScriptHandlerMgr::HandlerType::WEBSOCKET_ERROR);
//        CCLOG("handler = %d type = %d\n", handler, (int)ScriptHandlerMgr::HandlerType::WEBSOCKET_ERROR);
        if (0 != handler)
        {
            LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
            if (nullptr != stack)
            {
                stack->pushString(error.c_str(),(int)error.length());
                stack->executeFunctionByHandler(handler,  1);
            }
        }
//    }
}



#ifdef __cplusplus
static int tolua_collect_SIO_Client (lua_State* tolua_S)
{
    LuaSIOClient* self = (LuaSIOClient*) tolua_tousertype(tolua_S,1,0);
    Mtolua_delete(self);
    return 0;
}
#endif
/* function to release collected object via destructor */
static void tolua_reg_SIO_Client_type(lua_State* tolua_S)
{
    tolua_usertype(tolua_S, "cc.SIOClient");
}

/* method: create of class SIOClient */
#ifndef TOLUA_DISABLE_tolua_Cocos2d_SIOClient_create00
static int tolua_Cocos2d_SIOClient_create00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
    tolua_Error tolua_err;
    if (
        !tolua_isusertable(tolua_S,1,"cc.SIOClient",0,&tolua_err) ||
        !tolua_isnoobj(tolua_S,2,&tolua_err)
        )
        goto tolua_lerror;
    else
#endif
    {
        LuaSIOClient* client = new (std::nothrow) LuaSIOClient();
        tolua_pushusertype(tolua_S,(void*)client,"cc.SIOClient");
        tolua_register_gc(tolua_S,lua_gettop(tolua_S));
    }
    return 1;
#ifndef TOLUA_RELEASE
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'create'.",&tolua_err);
    return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

#ifndef TOLUA_DISABLE_tolua_Cocos2d_SIOClient_connect00
static int tolua_Cocos2d_SIOClient_connect00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
    tolua_Error tolua_err;
    if (
        !tolua_isusertype(tolua_S,1,"cc.SIOClient",0,&tolua_err) ||
        !tolua_isstring(tolua_S, 2, 0, &tolua_err) ||
        !tolua_isnoobj(tolua_S,3,&tolua_err)
        )
        goto tolua_lerror;
    else
#endif
    {
        LuaSIOClient* client = (LuaSIOClient*) tolua_tousertype(tolua_S,1,0);
        const char* urlName = ((const char*) tolua_tostring(tolua_S,2,0));
        cocos2d::network::SIOClient* c = cocos2d::network::SocketIO::getInstance()->connect(urlName, client);
        client->setClient(c);
    }
    return 1;
#ifndef TOLUA_RELEASE
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'create'.",&tolua_err);
    return 0;
#endif
}
#endif

/* method: disconnect of class SIOClient */
#ifndef TOLUA_DISABLE_tolua_Cocos2d_SIOClient_disconnect00
static int tolua_Cocos2d_SIOClient_disconnect00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
    tolua_Error tolua_err;
    if (
        !tolua_isusertype(tolua_S,1,"cc.SIOClient",0,&tolua_err) ||
        !tolua_isnoobj(tolua_S,2,&tolua_err)
        )
        goto tolua_lerror;
    else
#endif
    {
        LuaSIOClient* self = (LuaSIOClient*) tolua_tousertype(tolua_S,1,0);
        if (NULL != self ) {
            self->disconnect();
        }
    }
    return 1;
#ifndef TOLUA_RELEASE
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'disconnect'.",&tolua_err);
    return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: send of class SIOClient */
#ifndef TOLUA_DISABLE_tolua_Cocos2d_SIOClient_send00
static int tolua_Cocos2d_SIOClient_send00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
    tolua_Error tolua_err;
    if (
        !tolua_isusertype(tolua_S, 1, "cc.SIOClient", 0, &tolua_err) ||
        !tolua_isstring(tolua_S, 2, 0, &tolua_err)                ||
        !tolua_isnoobj(tolua_S, 3, &tolua_err)
        )
        goto tolua_lerror;
    else
#endif
    {
        LuaSIOClient* self = (LuaSIOClient*) tolua_tousertype(tolua_S,1,0);
        size_t size = 0;
        const char* data = (const char*) lua_tolstring(tolua_S, 2, &size);
        if ( NULL == data)
            return 0;

        std::string str = std::string(data);
        self->send(str);
    }
    return 1;
#ifndef TOLUA_RELEASE
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'send'.",&tolua_err);
    return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: emit of class SIOClient */
#ifndef TOLUA_DISABLE_tolua_Cocos2d_SIOClient_emit00
static int tolua_Cocos2d_SIOClient_emit00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
    tolua_Error tolua_err;
    if (
        !tolua_isusertype(tolua_S, 1, "cc.SIOClient", 0, &tolua_err) ||
        !tolua_isstring(tolua_S, 2, 0, &tolua_err)                ||
        !tolua_isstring(tolua_S, 3, 0, &tolua_err)                ||
        !tolua_isnoobj(tolua_S, 4, &tolua_err)
        )
        goto tolua_lerror;
    else
#endif
    {
        LuaSIOClient* self    = (LuaSIOClient*)  tolua_tousertype(tolua_S,1,0);
        size_t size1 = 0;
        const char* data = (const char*) lua_tolstring(tolua_S, 2, &size1);
        size_t size2 = 0;
        const char* args = (const char*) lua_tolstring(tolua_S, 3, &size2);

        if ( NULL == data)
            return 0;
        if ( NULL == args)
            return 0;

        std::string str      = std::string(data);
        std::string str_args = std::string(args);

        self->emit(str, str_args);
    }
    return 1;
#ifndef TOLUA_RELEASE
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'emit'.",&tolua_err);
    return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE


TOLUA_API int tolua_sio_client_open(lua_State* tolua_S)
{
    tolua_open(tolua_S);
    tolua_reg_SIO_Client_type(tolua_S);
    tolua_module(tolua_S,"cc",0);
    tolua_beginmodule(tolua_S,"cc");
#ifdef __cplusplus
    tolua_cclass(tolua_S,"SIOClient","cc.SIOClient","",tolua_collect_SIO_Client);
#else
    tolua_cclass(tolua_S,"SIOClient","cc.SIOClient","",NULL);
#endif
    tolua_beginmodule(tolua_S,"SIOClient");
      tolua_function(tolua_S, "create", tolua_Cocos2d_SIOClient_create00);
      tolua_function(tolua_S, "connect", tolua_Cocos2d_SIOClient_connect00);
      tolua_function(tolua_S, "disconnect", tolua_Cocos2d_SIOClient_disconnect00);
      tolua_function(tolua_S, "send", tolua_Cocos2d_SIOClient_send00);
      tolua_function(tolua_S, "emit", tolua_Cocos2d_SIOClient_emit00);
    tolua_endmodule(tolua_S);
    tolua_endmodule(tolua_S);
    return 1;
}

int tolua_Cocos2d_SIOClient_registerScriptHandler00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
    tolua_Error tolua_err;
    if (
        !tolua_isusertype(tolua_S,1,"cc.SIOClient",0,&tolua_err) ||
        !toluafix_isfunction(tolua_S,2,"LUA_FUNCTION",0,&tolua_err) ||
        !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
        !tolua_isnoobj(tolua_S,4,&tolua_err)
        )
        goto tolua_lerror;
    else
#endif
    {
        LuaSIOClient* self = (LuaSIOClient*) tolua_tousertype(tolua_S,1,0);
        if (NULL != self ) {
            int handler = (toluafix_ref_function(tolua_S,2,0));
            ScriptHandlerMgr::HandlerType handlerType = (ScriptHandlerMgr::HandlerType)((int)tolua_tonumber(tolua_S,3,0) + (int)ScriptHandlerMgr::HandlerType::WEBSOCKET_OPEN);
            ScriptHandlerMgr::getInstance()->addObjectHandler((void*)self, handler, handlerType);
//            CCLOG("LuaSIOClient::registerScriptHandler: %d %d\n", handler, (int)handlerType);
        }
    }
    return 1;
#ifndef TOLUA_RELEASE
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'registerScriptHandler'.",&tolua_err);
    return 0;
#endif
}

int tolua_Cocos2d_SIOClient_unregisterScriptHandler00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
    tolua_Error tolua_err;
    if (
        !tolua_isusertype(tolua_S,1,"cc.SIOClient",0,&tolua_err) ||
        !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
        !tolua_isnoobj(tolua_S,3,&tolua_err)
        )
        goto tolua_lerror;
    else
#endif
    {
        LuaSIOClient* self    = (LuaSIOClient*)  tolua_tousertype(tolua_S,1,0);
        if (NULL != self ) {
            ScriptHandlerMgr::HandlerType handlerType = (ScriptHandlerMgr::HandlerType)((int)tolua_tonumber(tolua_S,2,0) + (int)ScriptHandlerMgr::HandlerType::WEBSOCKET_OPEN);
            
            ScriptHandlerMgr::getInstance()->removeObjectHandler((void*)self, handlerType);
        }
    }
    return 1;
#ifndef TOLUA_RELEASE
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'unregisterScriptHandler'.",&tolua_err);
    return 0;
#endif
}

TOLUA_API int register_sio_client_manual(lua_State* tolua_S)
{
    if (nullptr == tolua_S)
        return 0 ;
    
    lua_pushstring(tolua_S,"cc.SIOClient");
    lua_rawget(tolua_S,LUA_REGISTRYINDEX);
    if (lua_istable(tolua_S,-1))
    {
        lua_pushstring(tolua_S,"registerScriptHandler");
        lua_pushcfunction(tolua_S,tolua_Cocos2d_SIOClient_registerScriptHandler00);
        lua_rawset(tolua_S,-3);
        lua_pushstring(tolua_S,"unregisterScriptHandler");
        lua_pushcfunction(tolua_S,tolua_Cocos2d_SIOClient_unregisterScriptHandler00);
        lua_rawset(tolua_S,-3);
    }
    lua_pop(tolua_S, 1);
    
    return 1;
}

#endif//(CC_TARGET_PLATFORM == CC_PLATFORM_IOS ...