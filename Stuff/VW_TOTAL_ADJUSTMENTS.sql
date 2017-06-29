create view VW_TOTAL_ADJUSTMENTS as
select claim_id, sum(adjustment_amount) as TOTAL_ADJUSTMENTS
from claim_adjustment
group by claim_id