$ ->
    gl = glutil.init document.getElementById 'canvas'

    vshader = glutil.load_shader 'vertex.glsl', 'v'
    fshader = glutil.load_shader 'fragment.glsl', 'f'

    shaderprog = glutil.set_shader_program [vshader, fshader]

    ###
    triangle = glutil.make_buf 'list', 3, [
            0.0,  1.0, 0.0,
            -1.0, -1.0, 0.0,
            1.0, -1.0, 0.0
        ]
    triangle_colors = glutil.make_buf 'list', 4, [
            1.0, 0.0, 0.0, 1.0,
            0.0, 1.0, 0.0, 1.0,
            0.0, 0.0, 1.0, 1.0
        ]

    square = glutil.make_buf 'strip', 3, [
            1.0,  1.0, 0.0,
            -1.0,  1.0, 0.0,
            1.0, -1.0, 0.0,
            -1.0, -1.0, 0.0
        ]
    square_colors = glutil.make_buf 'strip', 4, [
            0.5, 0.5, 1.0, 1.0,
            0.5, 0.5, 1.0, 1.0,
            0.5, 0.5, 1.0, 1.0,
            0.5, 0.5, 1.0, 1.0
        ]
    ###


    pyramid = glutil.make_buf 'list', 3, [
            0.0, 1.0, 0.0,
            -1.0, -1.0, 1.0,
            1.0, -1.0, 1.0,

            0.0, 1.0, 0.0,
            1.0, -1.0, 1.0,
            1.0, -1.0, -1.0,

            0.0, 1.0, 0.0,
            1.0, -1.0, -1.0,
            -1.0, -1.0, -1.0,

            0.0, 1.0, 0.0,
            -1.0, -1.0, -1.0,
            -1.0, -1.0, 1.0
        ]
    pyramid_colors = glutil.make_buf 'list', 4, [
            1.0, 0.0, 0.0, 1.0,
            0.0, 1.0, 0.0, 1.0,
            0.0, 0.0, 1.0, 1.0,

            1.0, 0.0, 0.0, 1.0,
            0.0, 0.0, 1.0, 1.0,
            0.0, 1.0, 0.0, 1.0,

            1.0, 0.0, 0.0, 1.0,
            0.0, 1.0, 0.0, 1.0,
            0.0, 0.0, 1.0, 1.0,

            1.0, 0.0, 0.0, 1.0,
            0.0, 0.0, 1.0, 1.0,
            0.0, 1.0, 0.0, 1.0
        ]
    ###
    cube = glutil.make_buf 'list', 3, [
            -1.0, -1.0, 1.0,
            1.0, -1.0, 1.0,
            1.0, 1.0, 1.0,
            -1.0, 1.0, 1.0,

            -1.0, -1.0, -1.0,
            -1.0, 1.0, -1.0,
            1.0, 1.0, -1.0,
            1.0, -1.0, -1.0,

            -1.0, 1.0, -1.0,
            -1.0, 1.0, 1.0,
            1.0, 1.0, 1.0,
            1.0, 1.0, -1.0,

            -1.0, -1.0, -1.0,
            1.0, -1.0, -1.0,
            1.0, -1.0, 1.0,
            -1.0, -1.0, 1.0,

            1.0, -1.0, -1.0,
            1.0, 1.0, -1.0,
            1.0, 1.0, 1.0,
            1.0, -1.0, 1.0,

            -1.0, -1.0, -1.0,
            -1.0, -1.0, 1.0,
            -1.0, 1.0, 1.0,
            -1.0, 1.0, -1.0
        ]
    cube_colors = glutil.make_buf 'list', 4, [
            1.0, 0.0, 0.0, 1.0,
            1.0, 0.0, 0.0, 1.0,
            1.0, 0.0, 0.0, 1.0,
            1.0, 0.0, 0.0, 1.0,

            1.0, 1.0, 0.0, 1.0,
            1.0, 1.0, 0.0, 1.0,
            1.0, 1.0, 0.0, 1.0,
            1.0, 1.0, 0.0, 1.0,

            0.0, 1.0, 0.0, 1.0,
            0.0, 1.0, 0.0, 1.0,
            0.0, 1.0, 0.0, 1.0,
            0.0, 1.0, 0.0, 1.0,

            1.0, 0.5, 0.5, 1.0,
            1.0, 0.5, 0.5, 1.0,
            1.0, 0.5, 0.5, 1.0,
            1.0, 0.5, 0.5, 1.0,

            1.0, 0.0, 1.0, 1.0,
            1.0, 0.0, 1.0, 1.0,
            1.0, 0.0, 1.0, 1.0,
            1.0, 0.0, 1.0, 1.0,

            0.0, 0.0, 1.0, 1.0,
            0.0, 0.0, 1.0, 1.0,
            0.0, 0.0, 1.0, 1.0,
            0.0, 0.0, 1.0, 1.0
        ]
    cube_indices = glutil.make_index_buf [
            0, 1, 2, 0, 2, 3,
            4, 5, 6, 4, 6, 7,
            8, 9, 10, 8, 10, 11,
            12, 13, 14, 12, 14, 15,
            16, 17, 18, 16, 18, 19,
            20, 21, 22, 20, 22, 23
        ]
    ###

    load_model = (filename) ->
        model = null
        $.ajax
            async: false
            dataType: 'json'
            url: filename
            success: (result) ->
                model = result

        model.vertex_buf = glutil.make_buf 'list', 3, model.vertices
        model.color_buf = glutil.make_buf 'list', 4, model.colors
        model.index_buf = glutil.make_index_buf model.indices

        model.draw = (shader) ->
            this.vertex_buf.bind shader.vertex
            this.color_buf.bind shader.color
            this.index_buf.bind()
            this.index_buf.draw()

        return model

    cube = load_model 'cube.json'

    gl.clearColor 0.0, 0.0, 0.0, 1.0
    gl.enable gl.DEPTH_TEST

    proj_matrix = mat4.create()
    modelview_matrix = mat4.create()

    matrix_stack = []
    push_matrix = ->
        copy = mat4.create()
        mat4.set modelview_matrix,copy
        matrix_stack.push copy
    pop_matrix = ->
        if matrix_stack.length > 0
            modelview_matrix = matrix_stack.pop()

    degToRad = (d) -> d * Math.PI / 180

    triangle_rotation = 0
    square_rotation = 0
    last_time = new Date().getTime()
    animate = ->
        now = new Date().getTime()

        elapsed = now - last_time
        triangle_rotation += (90*elapsed) / 1000.0
        square_rotation += (75*elapsed) / 1000.0

        last_time = now

    draw = ->
        gl.viewport 0, 0, gl.viewportWidth, gl.viewportHeight
        gl.clear gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT

        mat4.perspective 45, gl.viewportWidth / gl.viewportHeight, 0.1, 100.0, proj_matrix

        mat4.identity modelview_matrix

        #mat4.translate modelview_matrix, [-1.5, 0.0, -7.0]
        mat4.translate modelview_matrix, [-1.0, 0.0, -8.0]

        push_matrix()
        mat4.rotate modelview_matrix, degToRad(triangle_rotation), [0, 1, 0]

        shaderprog.set_matrix_uniforms proj_matrix, modelview_matrix
        #triangle.bind shaderprog.vertex
        #triangle_colors.bind shaderprog.color
        pyramid.bind shaderprog.vertex
        pyramid_colors.bind shaderprog.color

        #triangle.draw()
        pyramid.draw()

        pop_matrix()

        mat4.translate modelview_matrix, [3.0, 0.0, 0.0]

        push_matrix()
        #mat4.rotate modelview_matrix, degToRad(square_rotation), [1, 0, 0]
        mat4.rotate modelview_matrix, degToRad(square_rotation), [1,1,1]

        shaderprog.set_matrix_uniforms proj_matrix, modelview_matrix
        #square.bind shaderprog.vertex
        #square_colors.bind shaderprog.color
        #cube.bind shaderprog.vertex
        #cube_colors.bind shaderprog.color

        #cube_indices.bind()
        #cube_indices.draw()

        #square.draw()

        cube.draw shaderprog

        pop_matrix()

    (frame = ->
        requestAnimationFrame frame

        draw()
        animate()
    )()