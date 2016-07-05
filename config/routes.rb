Persephone::Engine.routes.draw do
  match "oauth/token" => 'tokens#create', via: :post, module: 'persephone'
end
