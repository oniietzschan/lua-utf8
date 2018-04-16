require 'busted'

local U = require 'utf8'

describe('When using :sub()', function()
  describe('When comparing output to standard library', function()
    it('substring in middle', function()
      assert.are.equal('BC', string.sub('ABCD', 2, 3))
      assert.are.equal('BC', U('ABCD'):sub(2, 3):tostring())
    end)

    it('omit "end" parameter.', function()
      assert.are.equal('ABCD', string.sub('ABCD', 1))
      assert.are.equal('ABCD', U('ABCD'):sub(1):tostring())
    end)

    it('"end" parameter is longer than string length.', function()
      assert.are.equal('BCD', string.sub('ABCD', 2, 5))
      assert.are.equal('BCD', U('ABCD'):sub(2, 5):tostring())
    end)

    it('"start" and "end" parameters are both out of bounds.', function()
      assert.are.equal('', string.sub('ABCD', 5, 6))
      assert.are.equal('', U('ABCD'):sub(5, 6):tostring())
    end)

    it('"start" parameter is 0.', function()
      assert.are.equal('AB', string.sub('ABCD', 0, 2))
      assert.are.equal('AB', U('ABCD'):sub(0, 2):tostring())
    end)

    it('"end" parameter is 0.', function()
      assert.are.equal('', string.sub('ABCD', 1, 0))
      assert.are.equal('', U('ABCD'):sub(1, 0):tostring())
    end)

    it('"start" and "end" parameters are both 0.', function()
      assert.are.equal('', string.sub('ABCD', 0, 0))
      assert.are.equal('', U('ABCD'):sub(0, 0):tostring())
    end)
  end)
end)

describe('When doing a bunch of stuff that the other author decided was a nice idea.', function()
  it('should not have any errors', function()
    -- source: https://github.com/cloudwu/skynet/issues/341
    local i341 = '这里只是释放了 uc 的内存, 但是 uc->pack.buffer 指向的数据并没有释放.'
    --            1 2 3 4 5 6 78901 2 3 456 7 890123456789012345 6 7 8 9 0 1 2 3 4 56
    --            1       5     10      15     20   15   30   35        40         46
    assert( #U(i341) == 46 )
    assert( U(i341):reverse():reverse():tostring() == i341 )
    assert( #U(i341):sub(2,3) == 2 )

    assert( U(i341):reverse():sub(-3,-2):tostring() == U(i341):sub(2,3):reverse():tostring() )

    local ustr = "aáâàbeéêèc-óôò€"

    local uobj = U(ustr)
    assert( tostring(uobj:sub(1, 2)) =="aá" )
    assert( tostring(uobj:sub(2, 3)) =="áâ" )
    assert( tostring(uobj:sub(-1,-1))=="€" )

    assert( uobj:sub(1, 2):tostring() =="aá" )
    assert( uobj:sub(2, 3):tostring() =="áâ" )
    assert( uobj:sub(-1,-1):tostring()=="€" )

    assert(#ustr == 26)
    assert(#uobj == 15)
    assert(type(uobj)  == "table")
    assert(uobj:type() == "ustring")
    assert(#U("a") == 1)
    assert(#U("Ô") == 1)
    assert(string.len(tostring(U("Ô"))) == #"Ô")

    assert(uobj == U(uobj), "convert must detect an already converted object")
    assert( tostring( U("áà"):rep(3) ) == "áàáàáà")

    assert( tostring( U("àeïôú"):reverse() ) == "úôïeà")
    assert(#ustr == 26)
    assert(#uobj == 15)


    assert( tostring(uobj .. " " .. uobj) == ustr.." "..ustr)
    assert( type(uobj) == type(uobj .. "str") )

    assert( uobj..1 )
    assert( " "..uobj )
  end)
end)



