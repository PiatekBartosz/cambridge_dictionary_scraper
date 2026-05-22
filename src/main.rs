use clap::Parser;
use console;
use dialoguer::Input;
use dialoguer::theme::ColorfulTheme;
use scraper::{Html, Selector};

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

struct Entry {
    definition: String,
    examples: Vec<String>,
}

fn scrape_definitions(html: &str) -> Vec<Entry> {
    let document = Html::parse_document(html);

    let def_sel = Selector::parse(".def.ddef_d").unwrap();
    let block_sel = Selector::parse(".def-block.ddef_block").unwrap();
    let example_sel = Selector::parse(".eg.deg").unwrap();

    document
        .select(&block_sel)
        .map(|block| {
            let definition = block
                .select(&def_sel)
                .next()
                .map(|d| d.text().collect::<String>().trim().to_string())
                .unwrap_or_default();

            let examples = block
                .select(&example_sel)
                .map(|e| e.text().collect::<String>().trim().to_string())
                .collect();

            Entry {
                definition,
                examples,
            }
        })
        .filter(|e| !e.definition.is_empty())
        .collect()
}

fn print_entries(query: &str, entries: &[Entry]) {
    println!("\n── {} ──\n", query.to_uppercase());
    for (i, entry) in entries.iter().enumerate() {
        println!("{}. {}", i + 1, entry.definition);
        for example in &entry.examples {
            println!("   • {}", example);
        }
        println!();
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
    let entries = scrape_definitions(&body);
    print_entries(&query, &entries);
    Ok(())
}
