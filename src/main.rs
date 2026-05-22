use clap::Parser;
use dialoguer::Input;
use dialoguer::theme::ColorfulTheme;

#[derive(Parser)]
#[command(
    version,
    name = "cam",
    about = "CLI for web scraping Cambridge Dictionary Word definitions"
)]
struct Args {
    /// Word that will have definition checked
    query: Option<String>,
}

fn get_query(args: Args) -> String {
    let theme = ColorfulTheme {
        prompt_suffix: console::style("".to_string()).for_stderr(),
        ..ColorfulTheme::default()
    };

    match args.query {
        Some(query) => query,
        None => Input::<String>::with_theme(&theme)
            .with_prompt(">")
            .interact_text()
            .unwrap(),
    }
}

fn main() {
    let args = Args::parse();
    let query = get_query(args);

    println!("Hello, world! {}", query);
}
