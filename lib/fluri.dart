// Copyright 2015 Workiva Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// A fluent URI mutation library.
///
/// # Importing
///
/// Once installed, import the fluri package:
///
///     import 'package:fluri/fluri.dart';
///
/// # Usage
///
/// The fluri library can be used in two different ways. You can
/// use the [Fluri] class directly as a replacement for [Uri],
/// or you can extend or mix in [FluriMixin] to add the fluent
/// mutation API to your own class.
///
/// ## Using [Fluri] Directly
///
///     import 'package:fluri/fluri.dart';
///
///     void main() {
///       Fluri fluri = new Fluri()
///         ..host = 'example.com'
///         ..scheme = 'https'
///         ..path = 'path/to/resource'
///         ..queryParameters = {'limit': '10', 'format': 'json'};
///
///       print(fluri.toString());
///       // https://example.com/path/to/resource?limit=10&format=json
///     }
///
/// ## Extending/Mixing [FluriMixin]
///
///     import 'package:fluri/fluri.dart';
///
///     // Option 1: Extending
///     class Request extends FluriMixin {}
///
///     // Option 2: Using as a Mixin
///     class Request extends Object with FluriMixin {}
///
///     void main() {
///       Request req = new Request()
///         ..host = 'example.com'
///         ..scheme = 'https'
///         ..path = 'path/to/resource'
///         ..queryParameters = {'limit': '10', 'format': 'json'};
///
///       print(req.uri.toString());
///       // https://example.com/path/to/resource?limit=10&format=json
///     }
library fluri;

/// A fluent URI mutation API built on top of [Uri].
///
/// [Fluri] can be used as a replacement for [Uri] and
/// gives you the benefit of easily and incrementally
/// mutating a URI.
///
///     import 'package:fluri/fluri.dart';
///
///     void main() {
///       Fluri fluri = new Fluri()
///         ..host = 'example.com'
///         ..scheme = 'https'
///         ..path = 'path/to/resource'
///         ..queryParameters = {'limit': '10', 'format': 'json'};
///
///       print(fluri.toString());
///       // https://example.com/path/to/resource?limit=10&format=json
///     }
///
/// If you need access to the underlying `Uri` instance, you
/// can access it via the `uri` property:
///
///     import 'package:fluri/fluri.dart';
///
///     void main() {
///       Fluri fluri = new Fluri();
///       Uri uri = fluri.uri;
///     }
class Fluri extends FluriMixin {
  /// Construct a new [Fluri] instance.
  ///
  /// A starting [uri] may be supplied which will be parsed
  /// by [Uri].[Uri.parse].
  Fluri([String uri]) {
    this.uri = Uri.parse(uri != null ? uri : '');
  }

  /// Construct a new [Fluri] instance from another [Fluri] instance.
  Fluri.from(Fluri fluri) : this.fromUri(fluri.uri);

  /// Construct a new [Fluri] instance from a [Uri] instance.
  Fluri.fromUri(Uri uri) {
    this.uri = uri;
  }

  @override
  String toString() => uri.toString();
}

/// A fluent URI mutation API built on top of [Uri] that
/// can be easily extended or mixed in.
///
/// Useful for classes that deal with URI-based actions,
/// like HTTP requests or WebSocket connections.
///
///     import 'package:fluri/fluri.dart';
///
///     // Option 1: Extending
///     class Request extends FluriMixin {}
///
///     // Option 2: Using as a Mixin
///     class Request extends Object with FluriMixin {}
///
///     void main() {
///       Request req = new Request()
///         ..host = 'example.com'
///         ..scheme = 'https'
///         ..path = 'path/to/resource'
///         ..queryParameters = {'limit': '10', 'format': 'json'};
///
///       print(req.uri.toString);
///       // https://example.com/path/to/resource?limit=10&format=json
///     }
class FluriMixin {
  /// The underlying [Uri] instance. All other URI mutations use this.
  Uri _uri = Uri.parse('');

  /// The full URI.
  Uri get uri => _uri;
  set uri(Uri uri) {
    _uri = uri ?? Uri.parse('');
  }

  /// The URI scheme or protocol. Examples: `http`, `https`, `ws`.
  String get scheme => _uri.scheme;
  set scheme(String scheme) {
    _uri = _uri.replace(scheme: scheme);
  }

  /// The URI host, including sub-domains and the tld.
  String get host => _uri.host;
  set host(String host) {
    _uri = _uri.replace(host: host);
  }

  /// The URI port number.
  int get port => _uri.port;
  set port(int port) {
    _uri = _uri.replace(port: port);
  }

  /// The URI path.
  String get path => _uri.path;
  set path(String path) {
    _uri = _uri.replace(path: path);
  }

  /// The URI path segments.
  Iterable<String> get pathSegments => _uri.pathSegments;
  set pathSegments(Iterable<String> pathSegments) {
    _uri = _uri.replace(pathSegments: pathSegments);
  }

  /// Append to the current path.
  void appendToPath(String path) {
    this.path = this.path + path;
  }

  /// Add a single path segment to the end of the current path.
  void addPathSegment(String pathSegment) {
    pathSegments = pathSegments.toList()..add(pathSegment);
  }

  /// The URI query string.
  String get query => _uri.query;
  set query(String query) {
    _uri = _uri.replace(query: query);
  }

  /// The URI query parameters.
  Map<String, String> get queryParameters => _uri.queryParameters;
  set queryParameters(Map<String, String> queryParameters) {
    _uri = _uri.replace(queryParameters: queryParameters);
  }

  /// Set a single query parameter.
  void setQueryParam(String param, String value) {
    updateQuery({param: value});
  }

  /// Update the URI query parameters, merging the given map with the
  /// current query parameters map instead of overwriting it.
  void updateQuery(Map<String, String> queryParameters) {
    var newQueryParameters = new Map<String, String>.from(this.queryParameters);
    newQueryParameters.addAll(queryParameters);
    _uri = _uri.replace(queryParameters: newQueryParameters);
  }

  /// The URI fragment or hash.
  String get fragment => _uri.fragment;
  set fragment(String fragment) {
    _uri = _uri.replace(fragment: fragment);
  }
}
