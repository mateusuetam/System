{ config, lib, pkgs, ... }:

{
options.my.firefox.enable = lib.mkEnableOption "Bundle do Firefox";

config = lib.mkIf config.my.firefox.enable {
programs.firefox = {
enable = true;

languagePacks = [ "pt-BR" "en-US" ];

policies = {
DisableTelemetry = true;
DisableFirefoxStudies = true;
DisablePocket = true;
DisableAccounts = true;
DisableFirefoxScreenshots = true;
DisableMasterPasswordCreation = true;
DisableProfileImport= true;
DisableProfileRefresh = true;
DisableSetDesktopBackground = true;
DisableFormHistory= true;
DisablePasswordReveal = true;
DontCheckDefaultBrowser = true;
PromptForDownloadLocation = true;
OfferToSaveLogins = false;
PasswordManagerEnabled = false;
AutofillAddressEnabled = false;
AutofillCreditCardEnabled = false;
OverrideFirstRunPage = "";
OverridePostUpdatePage = "";
DisplayBookmarksToolbar = "newtab";
DisplayMenuBar = "default-off";
SearchBar = "unified";
RequestedLocales = [ "pt-BR" ];

SearchEngines = {
Default = "Startpage";
Add = [
{
Name = "Startpage";
URLTemplate = "https://www.startpage.com/sp/search?query={searchTerms}";
Method = "GET";
IconURL = "https://www.startpage.com/favicon.ico";
}
];
Remove = [
"Google"
"Bing"
"DuckDuckGo"
"MercadoLivre"
"Perplexity"
"Wikipédia (pt)"
];
PreventInstalls = true;
};

EnableTrackingProtection = {
Value = true;
Locked = true;
Cryptomining = true;
Fingerprinting = true;
EmailTracking = true;
};

Permissions = {
Camera = {
BlockNewRequests = true;
Locked = true;
};

Microphone = {
BlockNewRequests = true;
Locked = true;
};

Location = {
BlockNewRequests = true;
Locked = true;
};

VirtualReality = {
BlockNewRequests = true;
Locked = true;
};

Autoplay = {
Default = "block-audio-video";
Locked = true;
};
};

ExtensionSettings = {
"*" = { installation_mode = "blocked"; };
"uBlock0@raymondhill.net" = {
installation_mode = "force_installed";
install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
};

"pt-BR@dictionaries.addons.mozilla.org" = {
installation_mode = "force_installed";
install_url = "https://addons.mozilla.org/firefox/downloads/latest/corretor/latest.xpi";
};
};

Preferences = {
# Abrir janelas e abas anteriores
"browser.startup.page" = 3;

# Confirmar fechamento
"browser.warnOnQuit" = true;
"browser.warnOnQuitShortcut" = true;

# Idioma e Localização de Websites
"intl.accept_languages" = "pt-br,pt,en-us,en";
"intl.locale.requested" = "pt-BR";

# Telemetria
"datareporting.policy.dataSubmissionEnabled" = false;
"browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
"browser.ping-centre.telemetry" = false;

# Removendo Recomendações da Mozilla
"browser.preferences.moreFromMozilla" = false;
"browser.contentblocking.cfr-features.enabled" = false;
"browser.contentblocking.cfr-addons.enabled" = false;

# Barra de Pesquisa e URL
"browser.search.suggest.enabled" = false;
"browser.search.suggest.enabled.private" = false;
"browser.urlbar.suggest.searches" = false;
"browser.urlbar.showSearchSuggestionsFirst" = false;
"browser.urlbar.speculativeConnect.enabled" = false;
"browser.urlbar.suggest.openpage" = false;
"browser.urlbar.suggest.topsites" = false;
"browser.urlbar.suggest.engines" = false;
"browser.urlbar.suggest.quickactions" = false;

# Interface e Comportamento
"browser.download.useDownloadDir" = false;
"browser.download.always_ask_before_handling_new_types" = true;
"browser.translations.enable" = false;
"browser.sessionstore.interval" = 60000;

# New Tab Page
"browser.newtabpage.activity-stream.showSearch" = false;
"browser.newtabpage.activity-stream.feeds.topsites" = false;
"browser.newtabpage.activity-stream.feeds.section.topstories" = false;
"browser.newtabpage.activity-stream.feeds.system.topstories" = false;
"browser.newtabpage.activity-stream.feeds.snippets" = false;
"browser.newtabpage.activity-stream.showSponsored" = false;
"browser.newtabpage.activity-stream.system.showSponsored" = false;
"browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
"browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
"browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
"browser.newtabpage.activity-stream.nova.enabled" = false;

# Bloqueio de IA / ML de Fábrica
"browser.ai.control.default" = "blocked";
"browser.ai.control.sidebarChatbot" = "blocked";
"browser.ai.control.smartWindow" = "blocked";
"browser.ai.control.smartTabGroups" = "blocked";
"browser.ai.control.linkPreviewKeyPoints" = "blocked";
"browser.ai.control.pdfjsAltText" = "blocked";
"browser.ai.control.translations" = "blocked";
"browser.ml.chat.enabled" = false;
"browser.ml.chat.page" = false;
"browser.ml.linkPreview.enabled" = false;
"extensions.ml.enabled" = false;

# Rede e Conexões
"dom.security.https_only_mode" = true;
"dom.security.https_only_mode_ever_enabled" = true;
"network.cookie.cookieBehavior" = 5;
"network.http.referer.XOriginPolicy" = 2;
"network.http.speculative-parallel-limit" = 0;
"network.prefetch-next" = false;
"network.predictor.enabled" = false;
"network.dns.disablePrefetch" = true;

# Privacidade Global e Proteção Contra Rastreadores
"browser.contentblocking.category" = "strict";
"privacy.globalprivacycontrol.enabled" = true;
"geo.enabled" = false;
"browser.send_pings" = false;
"dom.battery.enabled" = false;

# Mídia e Recursos
"media.eme.enabled" = true;
"media.navigator.enabled" = false;
"media.peerconnection.enabled" = false;
"media.peerconnection.use_document_iceservers" = false;
"media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
"pdfjs.enabledCache.state" = false;

# Performance
"media.ffmpeg.vaapi.enabled" = true;
"browser.cache.disk.enable" = false;
"browser.cache.disk.smart_size.enabled" = false;
"browser.cache.disk_cache_ssl" = false;
"browser.cache.offline.enable" = false;
"browser.cache.memory.enable" = true;
"browser.cache.memory.capacity" = 524288;
};
};
};
};
}
