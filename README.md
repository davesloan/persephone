# persephone
This gem provides token based OAuth2 authorization within Rails 4 apps that use Mongoid 5 (commonly referred to as client_credentials authorization). It is named after the Greek goddess of the underworld for no good reason other than I liked the name.

## Installation
In your Rails app gemfile, add the following:

```
gem 'persephone', '~> 1.0.0'
```

You will need to create applications that are allowed to authenticate with your API by doing the following in a rails console:

```
app = Persephone::App.create(name: 'This is a name.', scopes: ['scope1', 'scope2'])
```

You'll need your client ID and client secret in order to authenticate.

```
app.client_id
app.client_secret
```

## Authenticating

Persephone automatically provides you with the /oauth/token route. You will authenticate by POSTing a JSON payload containing your client_id and client_secret to the /oauth/token location on your API. A payload should look something like this:

```
{
    "client_id": "dcf155afc48376e40efa6173da6bf16a21aaaa89c888c1e730d001c1e58c816e",
    "client_secret": "da80b20365c221fcc7d0e3e3378ef9c6d6a03c9ea4014f50a94909d3cd395ad5"
}
```

If your client ID and secret are correct, you should receive a token as a response. This should look something like:

```
{
  "token": "63b27b3502241d75abadf72d607c172ec555216b60d3828aff12151f393e8b05",
  "expires": "2016-07-07T20:16:38.369+00:00"
}
```

All additional calls to the API will add the Authorization header, which should look something like:

```
Authorization: Bearer 63b27b3502241d75abadf72d607c172ec555216b60d3828aff12151f393e8b05
```

## Protecting API Resources

You'll need to create a controller concern with the following code:

```
module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authorize

    def authorize
      Persephone.authorized? request.headers
    end
  end
end
```

Then simply add the Authentication concern to any controller:

```
class SomeController < ApplicationController
  include Authentication

end
```

You can also skip authentication using the skip_before_action method:

```
class SomeController < ApplicationController
  include Authentication
  skip_before_action :authorize, only: :some_method
end
```

## Scopes

You can add some additional layers of security by locking down various controllers and methods to only allow access to applications with a specific scope. First, you need to set the scope on the application. By default, all applications receive the 'public' scope unless you specifically set the scopes value.

```
app = Persephone::App.find_by(client_id: 'dcf155afc48376e40efa6173da6bf16a21aaaa89c888c1e730d001c1e58c816e')
app.scopes = ['public', 'private']
app.save
```

Note that scopes must be an array of values.

Make a new concern for each scope:

```
module PrivateAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authorize_private_scope

    def authorize_private_scope
      Persephone.authorized? request.headers, ['private']
    end
  end
end

module PublicAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authorize_public_scope

    def authorize_public_scope
      Persephone.authorized? request.headers
    end
  end
end
```

Then simply include whichever concern is appropriate for your controller. You can require BOTH scopes if you include both concerns.

##Contributing

* Fork it
* Create your feature branch (git checkout -b my-new-feature)
* Commit your changes (git commit -am 'Added some feature')
* Push to the branch (git push origin my-new-feature)
* Create new Pull Request
