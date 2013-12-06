gl = null

window.glutil =

    init: (canvas) ->
        gl = null
        try
            gl = canvas.getContext "experimental-webgl"
            gl.viewportWidth = canvas.width
            gl.viewportHeight = canvas.height
        catch e

        if not gl
            console.error "Could not initialize WebGL :("
            return null

        return gl

    get_gl_context: ->
        if not gl
            console.error "WebGL not initialized"
            return null

        return gl

    load_shader: (filename,type) ->
        if not gl
            console.error "WebGL not initialized"
            return null

        text = null
        $.ajax
            async: false
            url: filename
            success: (result) ->
                text = result

        if not text
            console.error "Failed to load shader file #{filename}"
            return null

        shader = null
        if type == 'fragment' or type == 'pixel' or type == 'f' or type == 'p'
            shader = gl.createShader gl.FRAGMENT_SHADER
        else if type == 'vertex' or type == 'v'
            shader = gl.createShader gl.VERTEX_SHADER
        else
            console.error "Unsupported shader type ${type}"
            return null

        gl.shaderSource shader, text
        gl.compileShader shader

        if not gl.getShaderParameter shader, gl.COMPILE_STATUS
            console.error "Shader compilation failed:"
            console.error gl.getShaderInfoLog shader
            return null

        return shader

    set_shader_program: (shaders) ->
        if not gl
            console.error "WebGL not initialized"
            return null

        prog = gl.createProgram()
        for shader in shaders
            gl.attachShader prog, shader

        gl.linkProgram prog

        if not gl.getProgramParameter prog, gl.LINK_STATUS
            console.error "Shader program linking failed"
            return null

        gl.useProgram prog

        prog.vertex = gl.getAttribLocation prog, "vertex"
        gl.enableVertexAttribArray prog.vertex

        prog.color = gl.getAttribLocation prog, "color"
        gl.enableVertexAttribArray prog.color

        prog.projection_matrix_uni = gl.getUniformLocation prog, "u_proj_matrix"
        prog.modelview_matrix_uni = gl.getUniformLocation prog, "u_modelview_matrix"

        prog.set_matrix_uniforms = (proj, modelview) ->
            gl.uniformMatrix4fv this.projection_matrix_uni, false, proj
            gl.uniformMatrix4fv this.modelview_matrix_uni, false, modelview

        return prog

    make_buf: (layout, size, vertices) ->
        if not gl
            console.error "WebGL not initialized"
            return null

        buf = gl.createBuffer()

        gl.bindBuffer gl.ARRAY_BUFFER, buf
        raw_data = new Float32Array vertices
        gl.bufferData gl.ARRAY_BUFFER, raw_data, gl.STATIC_DRAW

        if layout == 'strip'
            buf.data_layout = gl.TRIANGLE_STRIP
        else if layout == 'list'
            buf.data_layout = gl.TRIANGLES
        else if layout == 'fan'
            buf.data_layout = gl.TRIANGLE_FAN
        else
            console.error "Unsupported buffer data layout #{layout}"
            return null

        buf.element_size = size
        buf.num_elements = vertices.length / size

        buf.bind = (attr) ->
            gl.bindBuffer gl.ARRAY_BUFFER, this
            gl.vertexAttribPointer attr, this.element_size, gl.FLOAT, false, 0, 0

        buf.draw = ->
            gl.drawArrays this.data_layout, 0, this.num_elements

        return buf

    make_index_buf: (indices) ->
        if not gl
            console.error "WebGL not initialized"
            return null

        buf = gl.createBuffer()

        gl.bindBuffer gl.ELEMENT_ARRAY_BUFFER, buf
        gl.bufferData gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(indices), gl.STATIC_DRAW

        buf.num_elements = indices.length

        buf.bind = ->
            gl.bindBuffer gl.ELEMENT_ARRAY_BUFFER, this

        buf.draw = ->
            gl.drawElements gl.TRIANGLES, this.num_elements, gl.UNSIGNED_SHORT, 0

        return buf
