import '../../../utils/constants_utils/app_api.constants.dart';
import 'endpoint.model.dart';

class EndpointServices {
  EndPoint getApiEndpoint(EndpointsNames name) {
    switch (name) {
      case EndpointsNames.register:
        return EndPoint(
          name: name,
          method: HttpMethods.post,
          url: '${AppApiConstants.baseUrlApi}/users',
        );
      case EndpointsNames.login:
        return EndPoint(
          name: name,
          method: HttpMethods.post,
          url: '${AppApiConstants.baseUrlApi}/auth/login',
        );
      case EndpointsNames.products:
        return EndPoint(
          name: name,
          method: HttpMethods.get,
          url: '${AppApiConstants.baseUrlApi}/products',
        );
    }
  }
}
