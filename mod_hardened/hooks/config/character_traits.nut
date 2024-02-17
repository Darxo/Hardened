foreach(index, traitArray in ::Const.CharacterTraits)
{
	if (traitArray[0] == "trait.irrational")
	{
		::Const.CharacterTraits.remove(index);
		break;
	}
}
