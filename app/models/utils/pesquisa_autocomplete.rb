module Utils
  class PesquisaAutocomplete
    def initialize(params)
      @params = params
    end

    def pesquisar
      busca = "busca_por_#{@params[:search_mode]}"
      send(busca) if respond_to?(busca)
    end

    def busca_por_orgao
      Pub::Orgao.proponente(@params[:term]).limit(100)
    end

    def busca_por_departamento
      Pub::Orgao.orgaos_filhos @params[:term], @params[:orgao_id]
    end

    def busca_por_identificacao
      Pub::IdentificacaoLogin.podem_ser_coordenador_ou_fiscal(@params[:term]).limit(150)
    end

    def busca_por_subcoordenador_projeto
      SubcoordenadorProjetoService.pesquisar_subcoordenador(@params[:coordenador_id],
                                                            @params[:term])
    end

    def busca_por_plap
      Pub::IdentificacaoLogin.where(id: Usuario.plap.pluck(:identificacao_login_id))
                             .por_nome(@params[:term])
    end

    def busca_por_projeto
      (ProjetoPed.por_titulo(@params[:term]) + ProjetoCurso.por_titulo(@params[:term])).uniq
    end

    def busca_por_coordenador
      ids = (ProjetoCurso.all.pluck(:coordenador_id) +
        ProjetoPed.all.pluck(:coordenador_id)).uniq
      Pub::IdentificacaoLogin.where(id: ids).por_nome(@params[:term])
    end

    def busca_por_assistente_projeto
      Pub::IdentificacaoLogin.assistente_valido(@params[:term], 150).uniq
    end

    def busca_por_projeto_tripartite
      Tripartite::Projeto.por_titulo(@params[:term]).uniq
    end

    def busca_por_coordenador_tripartite
      ids = Tripartite::Projeto.all.pluck(:coordenador_id).uniq
      Pub::IdentificacaoLogin.where(id: ids).por_nome(@params[:term])
    end
  end
end
