use rust_on_rails::prelude::*;
pub struct MyApp;

impl App for MyApp {
    async fn new(ctx: &mut Context<'_>) -> Box<dyn ComponentBuilder> {
        ctx.include_assets(include_assets!("./assets"));
        println!("my app");

        Box::new(Shape(ShapeType::Rectangle(50,50),"ffffff",None))

    }
}

create_entry_points!(MyApp);


