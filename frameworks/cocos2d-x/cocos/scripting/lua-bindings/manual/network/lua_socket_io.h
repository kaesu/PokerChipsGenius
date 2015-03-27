#ifndef __cocos2d_lua_bindings__lua_socket_io__
#define __cocos2d_lua_bindings__lua_socket_io__

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 || CC_TARGET_PLATFORM == CC_PLATFORM_MAC)

#ifdef __cplusplus
extern "C" {
#endif
#include "tolua++.h"
#ifdef __cplusplus
}
#endif

#include "network/SocketIO.h"
class LuaSIOClient: public cocos2d::network::SocketIO::SocketIO::SIODelegate
{
public:
    LuaSIOClient();
    virtual ~LuaSIOClient();
public:
    virtual void onConnect(cocos2d::network::SIOClient* client) override;
    virtual void onMessage(cocos2d::network::SIOClient* client, const std::string& data) override;
    virtual void onClose(cocos2d::network::SIOClient* client) override;
    virtual void onError(cocos2d::network::SIOClient* client, const std::string& data) override;
public:
    void setClient(cocos2d::network::SIOClient* client);
public:
    void send(std::string&);
    void emit(std::string&, std::string&);
    void disconnect();
private:
    cocos2d::network::SIOClient* _client;
};

TOLUA_API int tolua_sio_client_open(lua_State* tolua_S);
TOLUA_API int register_sio_client_manual(lua_State* tolua_S);

#endif //(CC_TARGET_PLATFORM == CC_PLATFORM_IOS ...

#endif /* defined(__cocos2d_lua_bindings__lua_socket_io__) */
