import pytest

from inventory_service.inventory_item.model import InventoryItem
from inventory_service.inventory_item.service import get_inventory_item


@pytest.mark.parametrize(
    "args, expected_result",
    [
        ((2,), InventoryItem(id=2, name="bob's strange item", quantity=333)),
        ((1,), InventoryItem(id=1, name="bob's mystery item", quantity=777)),
        ((3,), InventoryItem(id=3, name="bob's fine item", quantity=111)),
    ],
)
def test_inventory_item(args, expected_result):
    """test getting inventory items"""
    result = get_inventory_item(*args)
    assert expected_result == result
