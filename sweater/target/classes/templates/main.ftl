<#import "parts/common.ftl" as c>
<#-- search->main(Filter), add new post 3 field, with validation  -->

<#assign
user = Session.SPRING_SECURITY_CONTEXT.authentication.principal
name = user.getUsername()
isAdmin = user.isAdmin()
userid = user.getId()
>

<@c.page >

<div id="myModal" class="modal">
    <span class="close">&times;</span>
    <img class="modal-content" id="img01">
    <div id="caption"></div>
</div>

<div class="form-row">
    <div class="form-group col-md-6">
        <form method="get" action="/main" class="form-inline">
            <input type="text" name="filter" class="form-control" value="${filter?ifExists}"
                   placeholder="Search by tag">
            <button type="submit" class="btn btn-primary ml-2">Search</button>
        </form>
    </div>
</div>

<a class="btn btn-primary" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false"
   aria-controls="collapseExample">
    Add new Message
</a>
<div class="collapse <#if message??>show</#if>" id="collapseExample">
    <div class="form-group mt-3">
        <form method="post" enctype="multipart/form-data" class="was-validated">
            <div class="form-group">

                <input type="text" class="form-control ${(textError??)?string('is-invalid', '')}"
                       value="<#if message??>${message.text}</#if>" name="text" placeholder="Введите сообщение"  class="form-control is-valid" required/>
                <#if textError??>
                <div class="invalid-feedback">
                    ${textError}
                </div>
                </#if>
                <#--<div class="invalid-feedback">-->
                    <#--cannot be empty-->
                <#--</div>-->
            </div>
            <div class="form-group">
                <input type="text" class="form-control"  class="form-control is-valid"
                       value="<#if message??>${message.tag}</#if>" name="tag" placeholder="Тэг"  class="form-control is-valid"  required>
                <#if tagError??>
                    <div class="invalid-feedback">
                        ${tagError}
                    </div>
                </#if>

            </div>
            <div class="form-group">
                <div class="custom-file">
                    <input type="file" class="custom-file-input" id="file" required name="file">
                    <label class="custom-file-label" for="validatedCustomFile">Choose file...</label>
                </div>
            </div>
            <input type="hidden" name="_csrf" value="${_csrf.token}"/>
            <div class="form-group">
                <button type="submit" class="btn btn-success">Добавить</button>
            </div>
        </form>
    </div>

</div>

<div class="card-columns">
    <#list messages?reverse as message>
        <div class="card">
        <#if message.filename??>
        <img src="/img/${message.filename}" alt="myImg${message.id}" class="card-img-top" id="myImg${message.id}" onclick="Modal(this)">
        </#if>
            <div class="m-2">
                <span>${message.text}</span>
                <i>${message.tag}</i>
            </div>
            <div class="card-footer text-muted">
                ${message.authorName}


            <#if message.getAuthor().getId()?string == userid?string>


<div class="btn-group" role="group" aria-label="Basic example">
            <a class="btn btn-outline-primary" data-toggle="collapse" href="#changeMessage${message.getId()}" role="button"
               aria-expanded="false" aria-controls="collapseExample">
                Change message
            </a>

            <form method="post" enctype="multipart/form-data" action="/maindelete">
                <input type="hidden" value="${message.id}" name="id"  style="display: none" readonly>

                <input type="text" class="form-control ${(textError??)?string('is-invalid', '')}"
                       value="<#if message??>${message.text}</#if>" name="text"
                       placeholder="Введите сообщение"  style="display: none" readonly/>
                <input type="text" class="form-control"
                       value="<#if message??>${message.tag}</#if>" name="tag" placeholder="Тэг"  style="display: none" readonly>
                <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                <button type="submit" class="btn btn-danger">delete</button>
            </form>
</div>

            <div class="collapse" id="changeMessage${message.getId()}">
                <div class="form-group mt-3">
                    <form method="post" enctype="multipart/form-data" action="/mainchange" class="was-validated">

                        <div class="form-group">
                            <input type="hidden" value="${message.id}" name="id"  style="display: none" readonly>

                            <input type="hidden" value="${message.filename}" name="filename">
                            <input type="text" class="form-control ${(textError??)?string('is-invalid', '')}"
                                   value="<#if message??>${message.text}</#if>" name="text"
                                   placeholder="Введите сообщение"  class="form-control is-valid" required/>


                <#if textError??>
                <div class="invalid-feedback">
                    ${textError}
                </div>
                </#if>

                        </div>
                        <div class="form-group">
                            <input type="text" class="form-control"
                                   value="<#if message??>${message.tag}</#if>" name="tag" placeholder="Тэг"  class="form-control is-valid" required>
                <#if tagError??>
                    <div class="invalid-feedback">
                        ${tagError}
                    </div>
                </#if>

                        </div>
                        <div class="custom-file">
                            <input type="file" class="custom-file-input" id="file" required name="file">
                            <label class="custom-file-label" for="validatedCustomFile">Choose file...</label>

                        </div>
                        <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                        <div class="form-group">
                            <button type="submit" class="btn btn-success">change</button>
                        </div>
                    </form>

                </div>

            </div>

            </#if>
            </div>
        </div>
    <#else>
    No message
    </#list>
</div>

</@c.page>
