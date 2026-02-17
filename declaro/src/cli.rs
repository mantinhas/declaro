use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(name = "declaro")]
#[command(about = "A simple declarative wrapper for any linux distro")]
pub struct Cli {
    #[command(subcommand)]
    pub cmd: Command,
}

impl Cli {
    pub fn from_cli() -> Cli {
        Cli::parse()
    }
}

#[derive(Subcommand)]
#[command(rename_all = "kebab-case")]
pub enum Command {
    /// Reset state to declared
    Clean,
    /// List all declared packages
    List,
    /// Show diff between declared state and actual state
    Diff,
    /// Edit the packages.list file in your default editor ($VISUAL)
    Edit,
    /// Generate a new packages.list file
    Generate,
    /// Detect and install correct configuration for your package manager
    Install,
    /// Export the configurations and packages list to a tar.gz file
    Export {
        /// Target file
        file: String,
    },
    /// Import a declared state from a .tar.gz file or Git repository
    Import {
        /// Source file or repository
        source: String,
    },
    /// Show the status of a package (is declared and is installed)
    Status {
        /// Packages to check status for
        #[arg(required = true)]
        packages: Vec<String>,
    },
    /// Declare the specified packages as permanent
    Declare {
        /// Packages to declare
        #[arg(required = true)]
        packages: Vec<String>,
    },
}
