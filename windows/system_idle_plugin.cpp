#pragma warning(disable:4458)
#pragma warning(disable:4312)
#pragma warning(disable:5046)
#pragma warning(disable:4701)

#include "include/system_idle/system_idle_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>

#include <stdio.h>
#include <tchar.h>
#include <psapi.h>
#include <winuser.h>
#include <gdiplus.h>
#pragma comment(lib,"gdiplus.lib")


namespace {

  using flutter::EncodableMap;
  using flutter::EncodableValue;

  class SystemIdlePlugin : public flutter::Plugin {
    public:
      static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

      SystemIdlePlugin();

      virtual ~SystemIdlePlugin();

    private:
      // Called when a method is called on this plugin's channel from Dart.
      void HandleMethodCall(
          const flutter::MethodCall<flutter::EncodableValue> &method_call,
          std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  };


  // static
  void SystemIdlePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarWindows *registrar) {
    auto channel =
        std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            registrar->messenger(), "unitedideas.co/system_idle",
            &flutter::StandardMethodCodec::GetInstance());

    auto plugin = std::make_unique<SystemIdlePlugin>();

    channel->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto &call, auto result) {
          plugin_pointer->HandleMethodCall(call, std::move(result));
        });

    registrar->AddPlugin(std::move(plugin));
  }

  SystemIdlePlugin::SystemIdlePlugin() {}
  SystemIdlePlugin::~SystemIdlePlugin() {}


  int GetIdleTimeArgument(const flutter::MethodCall<>& method_call) {
    int idle_time;
    const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
    if (arguments) {
      auto idle_time_it = arguments->find(flutter::EncodableValue("idleTime"));
      if (idle_time_it != arguments->end()) {
        idle_time = std::get<int>(idle_time_it->second);
      }
    }
    return idle_time;
  }


  void SystemIdlePlugin::HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    if (method_call.method_name().compare("isIdle") == 0) {
      bool is_idle = false;

      int idle_time = GetIdleTimeArgument(method_call);

      LASTINPUTINFO li;
      li.cbSize = sizeof(LASTINPUTINFO);
      ::GetLastInputInfo(&li);

      // Calculate the time elapsed in seconds.
      DWORD te = ::GetTickCount();
      int elapsed = (te - li.dwTime) / 10;

      // Test against a preset timeout period in
      // seconds.
      if(idle_time < elapsed) {
        is_idle = true;
      }


      result->Success(flutter::EncodableValue(is_idle));
    } else {
      result->NotImplemented();
    }
  }





}  // namespace

void SystemIdlePluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  SystemIdlePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}