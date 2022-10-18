import 'dart:math';
import 'package:dart_spider/src/models/cleaner_model.dart';
import 'package:dart_spider/src/models/config_model.dart';
import 'package:dart_spider/src/models/enums.dart';
import 'package:dart_spider/src/models/target_model.dart';

Config? getConfig(
  Map<String, Config> masterConfig,
  String url,
  Extract extract, {
  Map<String, Config> priceConfig = const {},
}) {
  if (extract == Extract.product) {
    for (final i in masterConfig.keys) {
      if (url.contains(i)) {
        return masterConfig[i];
      }
    }
  } else if (extract == Extract.price && priceConfig.keys.isNotEmpty) {
    for (final i in priceConfig.keys) {
      if (url.contains(i)) {
        return priceConfig[i];
      }
    }
    return getConfig(
      masterConfig,
      url,
      Extract.product,
      priceConfig: priceConfig,
    );
  }
  return null;
}

String? cleanURL(Map<String, Config> masterConfig, String? url) {
  if (url != null) {
    Config? config = getConfig(masterConfig, url, Extract.product);
    if (config == null) {
      return null;
    }
    Target? target = fetchTarget(config.targets, url);
    if (target != null) {
      return runCleaner(url, target.cleaner);
    }
  }
  return null;
}

String generateUserAgent(UserAgentDevice type) {
  if (type == UserAgentDevice.desktop) {
    return "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_${randomNumber(11, 15)}_${randomNumber(4, 9)}) AppleWebKit/${randomNumber(530, 537)}.${randomNumber(30, 37)} (KHTML, like Gecko) Chrome/${randomNumber(80, 105)}.0.${randomNumber(3000, 4500)}.${randomNumber(60, 125)} Safari/${randomNumber(530, 537)}.${randomNumber(30, 36)}";
  } else {
    return "Mozilla/5.0 (Linux; Android ${randomNumber(7, 12)}; SM-G${randomNumber(400, 999)}V Build/NRD ${randomNumber(10, 90)}M) AppleWebKit/${randomNumber(530, 537)}.${randomNumber(30, 36)} (KHTML, like Gecko) Chrome/${randomNumber(80, 105)}.0.${randomNumber(3000, 4500)}.${randomNumber(60, 125)} Mobile Safari/${randomNumber(530, 537)}.${randomNumber(30, 36)}";
  }
}

String runCleaner(String url, Cleaner? cleaner) {
  //Amazon sponsored URLs
  if (url.contains("picassoRedirect.html")) {
    Uri parsed = Uri.parse(url);
    if (parsed.queryParameters.containsKey('url')) {
      url = "${parsed.origin}${parsed.queryParameters['url']}";
    }
  }

  //Set variables
  Uri og = Uri.parse(url);
  Map<String, String> params = {};

  //Empty cleaner, return path only, no params!
  if (cleaner == null) {
    return Uri.https(og.authority, og.path).toString();
  }

  //Blacklisted params! Add all other params.
  if (cleaner.blacklistParams != null) {
    og.queryParameters.forEach((key, value) {
      if (!cleaner.blacklistParams!.contains(key)) {
        params[key] = value;
      }
    });
  } else {
    params.addAll(og.queryParameters);
  }

  //Let's remove non-whitelisted params
  if (cleaner.whitelistParams != null) {
    List<String> toRemove = [];
    params.forEach((key, value) {
      if (!cleaner.whitelistParams!.contains(key)) {
        toRemove.add(key);
      }
    });
    params.removeWhere((k, v) => toRemove.contains(k));
  } else {
    params.clear();
  }

  //Let's append defined parameters
  if (cleaner.appendParams != null) {
    cleaner.appendParams!.forEach((key, value) {
      params[key] = value;
    });
  }

  return Uri.https(og.authority, og.path, params).toString();
}

Target? fetchTarget(List<Target> targets, String url) {
  for (final t in targets) {
    for (final urlPart in t.where) {
      if (url.contains(urlPart)) {
        return t;
      }
    }
  }
  return null;
}

int randomNumber(int min, int max) {
  return min + Random().nextInt(max - min);
}
