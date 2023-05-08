use super::affine_expression::{AffineExpression, AffineResult};
use super::expression_evaluator::SymbolicVariables;
use super::util::WitnessColumnNamer;
use super::FixedData;
use pil_analyzer::{PolyID, PolynomialReference, PolynomialType};

/// A purely symbolic evaluator.
/// Note: The affine expressions it returns will contain variables
/// for both the "current" and the "next" row, and for fixed columns as well,
/// and they are all different!
/// This means these AffineExpressions should not be confused with those
/// returned by the EvaluationData struct.
/// The only IDs are allocated in the following order:
/// witness columns, next witness columns, fixed columns, next fixed columns.
#[derive(Clone)]
pub struct SymbolicEvaluator<'a> {
    fixed_data: &'a FixedData<'a>,
}

impl<'a> SymbolicEvaluator<'a> {
    pub fn new(fixed_data: &'a FixedData<'a>) -> Self {
        SymbolicEvaluator { fixed_data }
    }

    /// Turns the ID into a polynomial reference (with empty name, though).
    pub fn poly_from_id(&self, id: usize) -> PolynomialReference {
        let witness_count = self.fixed_data.witness_ids.len();
        let (poly_id, ptype, next) = if id < 2 * witness_count {
            (
                (id % witness_count) as u64,
                PolynomialType::Committed,
                id >= witness_count,
            )
        } else {
            let fixed_count = self.fixed_data.fixed_col_values.len();
            let fixed_id = id - 2 * witness_count;
            (
                (fixed_id % fixed_count) as u64,
                PolynomialType::Constant,
                fixed_id >= fixed_count,
            )
        };
        PolynomialReference {
            name: Default::default(),
            poly_id: Some(PolyID { id: poly_id, ptype }),
            index: None,
            next,
        }
    }

    pub fn id_for_fixed_poly(&self, poly: &PolynomialReference) -> usize {
        let witness_count = self.fixed_data.witness_ids.len();
        let fixed_count = self.fixed_data.fixed_col_values.len();

        let id = poly.poly_id() as usize;
        2 * witness_count + id + if poly.next { fixed_count } else { 0 }
    }
    pub fn id_for_witness_poly(&self, poly: &PolynomialReference) -> usize {
        let witness_count = self.fixed_data.witness_ids.len();
        poly.poly_id() as usize + if poly.next { witness_count } else { 0 }
    }
}

impl<'a> SymbolicVariables for SymbolicEvaluator<'a> {
    fn value(&self, poly: &PolynomialReference) -> AffineResult {
        // TODO arrays
        Ok(AffineExpression::from_variable_id(
            match poly.poly_id.unwrap().ptype {
                PolynomialType::Committed => self.id_for_witness_poly(poly),
                PolynomialType::Constant => self.id_for_fixed_poly(poly),
                PolynomialType::Intermediate => panic!(),
            },
        ))
    }

    fn format(&self, expr: AffineExpression) -> String {
        expr.format(self)
    }
}

impl<'a> WitnessColumnNamer for SymbolicEvaluator<'a> {
    fn name(&self, id: usize) -> String {
        // This is still needed for the BitConstraint solving.
        let mut poly = self.poly_from_id(id);
        poly.name = self.fixed_data.poly_name(poly.poly_id.unwrap()).to_string();
        poly.to_string()
    }
}