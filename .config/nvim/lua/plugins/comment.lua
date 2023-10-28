local function createPreHook()
    return function(ctx)
        local commentUtil = require('comment.utils')
        local tsContextUtil = require('ts_context_commentstring.utils')
        local tsContext = require('ts_context_commentstring')

        local type = ctx.ctype == commentUtil.ctype.linewise
            and '__default' or '__multiline'
        local location = nil

        if ctx.ctype == commentUtil.ctype.blockwise then
            location = {
                ctx.range.srow - 1,
                ctx.range.scol,
            }
        elseif ctx.cmotion == commentUtil.cmotion.v
            or ctx.cmotion == commentUtil.cmotion.V
        then
            location = tsContextUtil.get_visual_start_location()
        end

        return tsContext.calculate_commentstring({
            key = type,
            location = location,
        })
    end
end

return {
    --"https://github.com/jake-stewart/comment.nvim",
    dir="~/clones/comment.nvim",
    enabled = true,
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
        require("comment").setup({
            pre_hook = createPreHook()
        })
    end
}
