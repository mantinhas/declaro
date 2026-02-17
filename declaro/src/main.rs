use declaro::cli::Cli;

fn main() {
    let args = Cli::from_cli();
    match args.cmd {
        declaro::cli::Command::List => todo!("list"),
        declaro::cli::Command::Diff => todo!("diff"),
        declaro::cli::Command::Edit => todo!("edit"),
        declaro::cli::Command::Clean => todo!("clean"),
        declaro::cli::Command::Install => todo!("install"),
        declaro::cli::Command::Generate => todo!("generate"),
        declaro::cli::Command::Import { .. } => todo!("import"),
        declaro::cli::Command::Export { .. } => todo!("export"),
        declaro::cli::Command::Status { .. } => todo!("status"),
        declaro::cli::Command::Declare { .. } => todo!("declare"),
    }
}
