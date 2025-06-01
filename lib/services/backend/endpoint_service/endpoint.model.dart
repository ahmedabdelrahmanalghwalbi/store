enum EndpointsNames { login, register, products }

enum HttpMethods { get, post, put, delete }

class EndPoint {
  final EndpointsNames name;
  final HttpMethods method;
  final String url;

  EndPoint({required this.name, required this.method, required this.url});

  EndPoint copyWith({EndpointsNames? name, HttpMethods? method, String? url}) {
    return EndPoint(
      name: name ?? this.name,
      method: method ?? this.method,
      url: url?.trim() ?? this.url.trim(),
    );
  }

  @override
  bool operator ==(covariant EndPoint other) {
    if (identical(this, other)) return true;

    return other.name == name && other.method == method && other.url == url;
  }

  @override
  int get hashCode => name.hashCode ^ method.hashCode ^ url.hashCode;

  @override
  String toString() =>
      'EndPoint(name: $name, method: ${method.toString()}, url: $url)';
}
