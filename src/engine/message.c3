module engine::message::msg;

alias Message = usz;

macro Message @new() {
	String $ret = "";
	int $data = $$LINE;
	$for var $x = 0; $data != 0; $x++:
		char $t = ($data % 10) + '0';
		$data = $data / 10;
		$ret = $ret +++ $t;
	$endfor
	String $ret2 = "";
	$for var $i = $ret.len - 1; $i >= 0; $i--:
		$ret2 = $ret2 +++ $ret[$i];
	$endfor
	return @str_hash($$FILE +++ $ret2);
}
