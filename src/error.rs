use thiserror::Error;

#[derive(Debug, Error)]
pub enum Error {
    /// For starter, to remove as code matures.
	#[error("Generic error: {0}")]
    Generic(String)
}