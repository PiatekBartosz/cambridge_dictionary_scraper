use clap::Parser;
use console;
use dialoguer::Input;
use dialoguer::theme::ColorfulTheme;
use std::fs;

#[derive(Parser)]
#[command(name = "cam", about = "Fetch Cambridge Dictionary page for a word")]
struct Args {
    query: Option<String>,
}

fn get_query(args: &Args) -> String {
    let theme = ColorfulTheme {
        prompt_suffix: console::style("".to_string()).for_stderr(),
        ..ColorfulTheme::default()
    };
    match &args.query {
        Some(query) => query.clone(),
        None => Input::<String>::with_theme(&theme)
            .with_prompt(">")
            .interact_text()
            .unwrap(),
    }
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = Args::parse();

    let query = get_query(&args);
    let url = format!(
        "https://dictionary.cambridge.org/dictionary/english/{}",
        query
    );
    let body = reqwest::blocking::get(&url)?.text()?;
    fs::write(format!("{}.txt", query), &body)?;
    println!("Saved to {}.txt", query);
    Ok(())
}
